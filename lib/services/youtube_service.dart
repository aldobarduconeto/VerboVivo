import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media_model.dart';

export '../models/media_model.dart';

class YouTubeService {
  const YouTubeService({this.client});
  final http.Client? client;
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

  // Cache em memória com TTL para pesquisas recentes de vídeos/músicas
  static final Map<String, ({List<VideoItem> items, DateTime expiresAt})>
      _searchCache = {};

  static void clearCache() => _searchCache.clear();

  Future<List<VideoItem>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty || q.length > 220) {
      throw const SearchUnavailable('Consulta de pesquisa inválida.');
    }

    final cacheKey = q.toLowerCase();
    final cached = _searchCache[cacheKey];
    if (cached != null && DateTime.now().isBefore(cached.expiresAt)) {
      return cached.items;
    }

    final searchClient = client ?? http.Client();
    try {
      final preferred = await _trySearch(
          searchClient, _invidious.first, q, const Duration(seconds: 3));
      if (preferred.isNotEmpty) {
        _searchCache[cacheKey] = (
          items: preferred,
          expiresAt: DateTime.now().add(const Duration(minutes: 20)),
        );
        return preferred;
      }
      final items = await _searchAlternatives(searchClient, q);
      if (items.isNotEmpty) {
        _searchCache[cacheKey] = (
          items: items,
          expiresAt: DateTime.now().add(const Duration(minutes: 20)),
        );
      }
      return items;
    } finally {
      if (client == null) searchClient.close();
    }
  }

  Future<List<VideoItem>> _searchAlternatives(
      http.Client searchClient, String query) {
    final result = Completer<List<VideoItem>>();
    var remaining = _invidious.length - 1;
    for (final source in _invidious.skip(1)) {
      unawaited(
        _trySearch(searchClient, source, query, const Duration(seconds: 5))
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

  // Cache em memória para resultados de podcasts
  static final Map<String, ({List<PodcastItem> items, DateTime expiresAt})>
      _podcastCache = {};

  static void clearCache() => _podcastCache.clear();

  Future<List<PodcastItem>> search(String topic) async {
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
      return cached.items;
    }

    final searchClient = client ?? http.Client();
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
        _podcastCache[cacheKey] = (
          items: results,
          expiresAt: DateTime.now().add(const Duration(minutes: 20)),
        );
      }
      return results;
    } finally {
      if (client == null) searchClient.close();
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
