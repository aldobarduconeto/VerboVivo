import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_model.dart';

export '../models/media_model.dart';

class YouTubeService {
  const YouTubeService({this.client});
  final http.Client? client;

  static http.Client? _defaultClient;
  static http.Client get _sharedClient => _defaultClient ??= http.Client();

  // Public HTTPS instances listed by the Invidious project.
  static const _invidious = [
    'https://yt.chocolatemoo53.com',
    'https://inv.nadeko.net',
    'https://invidious.nerdvpn.de',
    'https://invidious.tiekoetter.com',
    'https://invidious.privacydev.net',
    'https://invidious.drgns.space',
    'https://vid.priv.au',
  ];
  static final _videoId = RegExp(r'^[A-Za-z0-9_-]{11}$');

  static const int _maxCacheSize = 80;

  // Cache em memória com TTL para pesquisas recentes de vídeos/músicas
  static final Map<String, ({List<VideoItem> items, DateTime expiresAt})>
      _searchCache = {};
  static final Map<String, Future<List<VideoItem>>> _inFlightSearches = {};

  static void clearCache() {
    _searchCache.clear();
    _inFlightSearches.clear();
  }

  static void _saveToCache(String key, List<VideoItem> items) {
    if (_searchCache.length >= _maxCacheSize) {
      _searchCache.remove(_searchCache.keys.first);
    }
    _searchCache[key] = (
      items: items,
      expiresAt: DateTime.now().add(const Duration(minutes: 25)),
    );
  }

  Future<List<VideoItem>> search(String query) {
    final q = query.trim();
    if (q.isEmpty || q.length > 220) {
      throw const SearchUnavailable('Consulta de pesquisa inválida.');
    }

    final cacheKey = q.toLowerCase();
    final cached = _searchCache[cacheKey];
    if (cached != null && DateTime.now().isBefore(cached.expiresAt)) {
      return Future.value(cached.items);
    }

    // Se já existe uma pesquisa idêntica em curso, compartilha o Future
    final inFlight = _inFlightSearches[cacheKey];
    if (inFlight != null) {
      return inFlight;
    }

    final requestFuture = _executeSearch(q, cacheKey);
    _inFlightSearches[cacheKey] = requestFuture;
    return requestFuture.whenComplete(() => _inFlightSearches.remove(cacheKey));
  }

  Future<List<VideoItem>> _executeSearch(String query, String cacheKey) async {
    final searchClient = client ?? _sharedClient;
    final ownsClient = client != null;

    try {
      // Dispara corrida concorrente entre os 3 espelhos mais rápidos
      final topInstances = _invidious.take(3);
      final futures = topInstances
          .map((host) => _trySearch(searchClient, host, query, const Duration(milliseconds: 2600)))
          .toList();

      final winner = await _firstNonEmpty(futures);
      if (winner != null && winner.isNotEmpty) {
        _saveToCache(cacheKey, winner);
        return winner;
      }

      // Se os 3 primeiros falharem, consulta as alternativas restantes em paralelo
      final items = await _searchAlternatives(searchClient, query);
      if (items.isNotEmpty) {
        _saveToCache(cacheKey, items);
      }
      return items;
    } finally {
      if (ownsClient) searchClient.close();
    }
  }

  static Future<List<VideoItem>?> _firstNonEmpty(
      List<Future<List<VideoItem>>> futures) async {
    if (futures.isEmpty) return null;
    final completer = Completer<List<VideoItem>?> ();
    var remaining = futures.length;

    for (final future in futures) {
      future.then((items) {
        if (items.isNotEmpty && !completer.isCompleted) {
          completer.complete(items);
        } else {
          remaining--;
          if (remaining == 0 && !completer.isCompleted) {
            completer.complete(null);
          }
        }
      }).catchError((_) {
        remaining--;
        if (remaining == 0 && !completer.isCompleted) {
          completer.complete(null);
        }
      });
    }

    return completer.future;
  }

  Future<List<VideoItem>> _searchAlternatives(
      http.Client searchClient, String query) {
    final result = Completer<List<VideoItem>>();
    final alternatives = _invidious.skip(3).toList();
    if (alternatives.isEmpty) {
      return Future.error(const SearchUnavailable(
          'A busca de vídeos está indisponível no momento. '
          'Você pode pesquisar diretamente no YouTube ou tentar novamente.'));
    }

    var remaining = alternatives.length;
    for (final source in alternatives) {
      unawaited(
        _trySearch(searchClient, source, query, const Duration(seconds: 4))
            .then((items) {
          remaining--;
          if (result.isCompleted) return;
          if (items.isNotEmpty) {
            result.complete(items);
          } else if (remaining == 0) {
            result.completeError(const SearchUnavailable(
                'A busca de vídeos está indisponível no momento. '
                'Você pode pesquisar diretamente no YouTube ou tentar novamente.'));
          }
        }).catchError((_) {
          remaining--;
          if (!result.isCompleted && remaining == 0) {
            result.completeError(const SearchUnavailable(
                'A busca de vídeos está indisponível no momento. '
                'Você pode pesquisar diretamente no YouTube ou tentar novamente.'));
          }
        }),
      );
    }
    return result.future;
  }

  Future<List<VideoItem>> _trySearch(http.Client searchClient, String host,
      String query, Duration timeout) async {
    try {
      return await _publicSearch(searchClient, host, query, timeout);
    } catch (_) {
      return const [];
    }
  }

  Future<List<VideoItem>> _publicSearch(http.Client searchClient, String host,
      String query, Duration timeout) async {
    final uri = Uri.parse('$host/api/v1/search').replace(queryParameters: {
      'q': query,
      'type': 'video',
      'sort_by': 'relevance',
      'page': '1',
      'region': 'BR',
    });
    final response = await searchClient
        .get(uri, headers: {'Accept': 'application/json'}).timeout(timeout);
    if (response.statusCode != 200) return const [];
    final raw = jsonDecode(utf8.decode(response.bodyBytes));
    if (raw is! List) throw const FormatException();
    final items = <VideoItem>[];
    final seen = <String>{};
    for (final value in raw.whereType<Map>()) {
      final id = '${value['videoId'] ?? ''}';
      if (!_videoId.hasMatch(id) || !seen.add(id)) continue;
      items.add(VideoItem(
          id: id,
          title: '${value['title'] ?? 'Vídeo'}',
          channel: '${value['author'] ?? 'YouTube'}',
          thumbnail: 'https://i.ytimg.com/vi/$id/hqdefault.jpg'));
      if (items.length == 12) break;
    }
    return items;
  }

  static VideoItem? videoFromLink(String input) {
    final value = input.trim();
    final uri = Uri.tryParse(value.contains('://') ? value : 'https://$value');
    if (uri == null || !{'http', 'https'}.contains(uri.scheme)) return null;
    final segments = uri.pathSegments;
    String? id;
    if (uri.host == 'youtu.be' && segments.isNotEmpty) {
      id = segments.first;
    } else if ({
      'youtube.com',
      'www.youtube.com',
      'm.youtube.com',
      'music.youtube.com'
    }.contains(uri.host)) {
      if (uri.path == '/watch') id = uri.queryParameters['v'];
      if (segments.length >= 2 &&
          {'shorts', 'live', 'embed'}.contains(segments.first))
        id = segments[1];
    }
    if (id == null || !_videoId.hasMatch(id)) return null;
    return VideoItem(
        id: id,
        title: 'Vídeo do YouTube',
        channel: 'YouTube',
        thumbnail: 'https://i.ytimg.com/vi/$id/hqdefault.jpg');
  }

  static String? extractVideoId(String input) {
    return videoFromLink(input)?.id;
  }
}

class PodcastService {
  const PodcastService({this.client});
  final http.Client? client;

  static http.Client? _defaultClient;
  static http.Client get _sharedClient => _defaultClient ??= http.Client();

  static const int _maxCacheSize = 80;

  // Cache em memória para resultados de podcasts
  static final Map<String, ({List<PodcastItem> items, DateTime expiresAt})>
      _podcastCache = {};
  static final Map<String, Future<List<PodcastItem>>> _inFlightSearches = {};

  static void clearCache() {
    _podcastCache.clear();
    _inFlightSearches.clear();
  }

  static void _saveToCache(String key, List<PodcastItem> items) {
    if (_podcastCache.length >= _maxCacheSize) {
      _podcastCache.remove(_podcastCache.keys.first);
    }
    _podcastCache[key] = (
      items: items,
      expiresAt: DateTime.now().add(const Duration(minutes: 25)),
    );
  }

  Future<List<PodcastItem>> search(String topic) {
    final clean = topic
        .replaceAll(RegExp(r'\bpodcast\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (clean.isEmpty) {
      throw const SearchUnavailable('Termo de busca para podcast inválido.');
    }

    final cacheKey = clean.toLowerCase();
    final cached = _podcastCache[cacheKey];
    if (cached != null && DateTime.now().isBefore(cached.expiresAt)) {
      return Future.value(cached.items);
    }

    final inFlight = _inFlightSearches[cacheKey];
    if (inFlight != null) {
      return inFlight;
    }

    final requestFuture = _executeSearch(clean, cacheKey);
    _inFlightSearches[cacheKey] = requestFuture;
    return requestFuture.whenComplete(() => _inFlightSearches.remove(cacheKey));
  }

  Future<List<PodcastItem>> _executeSearch(String clean, String cacheKey) async {
    final searchClient = client ?? _sharedClient;
    final ownsClient = client != null;

    try {
      List<PodcastItem> results = [];
      // 1. Busca prioritária pelo termo específico exato fornecido
      results = await _queryItunes(searchClient, clean);

      // 2. Se não encontrou episódios com o termo exato, tenta com contexto 'cristão'
      if (results.isEmpty) {
        final isAlreadyChristian = RegExp(
          r'\b(crist[aã]o|evang[eé]lico|b[ií]blico|igreja|deus|jesus|pastor)\b',
          caseSensitive: false,
        ).hasMatch(clean);
        if (!isAlreadyChristian) {
          results = await _queryItunes(searchClient, '$clean cristão');
        }
      }

      // 3. Fallback inteligente com reflexão cristã
      if (results.isEmpty) {
        results = await _queryItunes(searchClient, 'reflexão cristã');
      }

      if (results.isNotEmpty) {
        _saveToCache(cacheKey, results);
      }
      return results;
    } finally {
      if (ownsClient) searchClient.close();
    }
  }

  Future<List<PodcastItem>> _queryItunes(http.Client httpClient, String term) async {
    try {
      final uri = Uri.https('itunes.apple.com', '/search', {
        'term': term,
        'media': 'podcast',
        'entity': 'podcastEpisode',
        'country': 'BR',
        'limit': '30',
      });
      final response = await httpClient.get(uri).timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) return const [];
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! Map || data['results'] is! List) return const [];
      final items = <PodcastItem>[];
      final seen = <String>{};
      for (final entry in (data['results'] as List).whereType<Map>()) {
        final audioUrl = entry['episodeUrl'];
        if (audioUrl is! String) continue;
        final uri = Uri.tryParse(audioUrl);
        if (uri == null ||
            uri.scheme != 'https' ||
            uri.host.isEmpty ||
            !seen.add(audioUrl)) continue;
        final millis = entry['trackTimeMillis'];
        items.add(PodcastItem(
          title: entry['trackName'] as String? ?? 'Episódio',
          show: entry['collectionName'] as String? ?? 'Podcast',
          audioUrl: audioUrl,
          duration: millis is num && millis > 0
              ? Duration(milliseconds: millis.round())
              : null,
          artwork: entry['artworkUrl600'] as String? ??
              entry['artworkUrl160'] as String? ??
              '',
        ));
      }
      return items;
    } catch (_) {
      return const [];
    }
  }
}
