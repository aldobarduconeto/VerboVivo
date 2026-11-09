import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/media_model.dart';

export '../models/media_model.dart';

class YouTubeStreamService {
  const YouTubeStreamService();

  static const _invidiousHosts = [
    'inv.nadeko.net',
    'invidious.nerdvpn.de',
    'invidious.privacydev.net',
    'vid.priv.au',
    'invidious.tiekoetter.com',
    'invidious.drgns.space',
  ];

  static const _pipedHosts = [
    'pipedapi.kavin.rocks',
    'api.piped.privacydev.net',
    'piped-api.garudalinux.org',
  ];

  // Cache em memória para início de reprodução em 0ms
  static final Map<String, ({ResolvedVideo video, DateTime expiresAt})> _cache =
      {};

  static ResolvedVideo? getCached(String videoId) {
    final entry = _cache[videoId];
    if (entry != null && DateTime.now().isBefore(entry.expiresAt)) {
      return entry.video;
    }
    _cache.remove(videoId);
    return null;
  }

  static void setCached(String videoId, ResolvedVideo resolved) {
    _cache[videoId] = (
      video: resolved,
      expiresAt: DateTime.now().add(const Duration(hours: 3)),
    );
  }

  static void clearCache() {
    _cache.clear();
  }

  /// Pré-aquece a resolução de streams em segundo plano
  Future<void> preload(String videoId) async {
    if (getCached(videoId) != null) return;
    try {
      await resolve(videoId);
    } catch (_) {}
  }

  Future<ResolvedVideo> resolve(String videoId) async {
    if (!RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(videoId)) {
      throw const FormatException('Identificador de vídeo inválido.');
    }

    // 0. Se já estiver no cache, retorna imediatamente (0 ms)
    final cached = getCached(videoId);
    if (cached != null) return cached;

    // 1. Corrida concorrente e paralela entre o extrator direto e os melhores espelhos
    try {
      final futures = <Future<ResolvedVideo?>>[
        _fastYoutubeExplode(videoId),
        _fastInvidiousRace(videoId),
        _fastPipedRace(videoId),
      ];

      final winner = await _firstSuccessful<ResolvedVideo>(futures).timeout(
        const Duration(milliseconds: 3200),
        onTimeout: () => null,
      );

      if (winner != null) {
        setCached(videoId, winner);
        return winner;
      }
    } catch (_) {}

    // 2. Fallback imediato: URL direta para decodificação nativa interna pelo libmpv
    final directFallback =
        ResolvedVideo(Uri.parse('https://www.youtube.com/watch?v=$videoId'));
    setCached(videoId, directFallback);
    return directFallback;
  }

  Future<ResolvedVideo?> _fastYoutubeExplode(String videoId) async {
    final youtube = YoutubeExplode();
    try {
      final manifest = await youtube.videos.streamsClient
          .getManifest(videoId)
          .timeout(const Duration(milliseconds: 2600));

      final muxed =
          manifest.muxed.where((s) => s.url.scheme == 'https').toList();
      if (muxed.isNotEmpty) {
        muxed.sort((a, b) => b.bitrate.compareTo(a.bitrate));
        return ResolvedVideo(muxed.first.url);
      }

      final videos =
          manifest.videoOnly.where((s) => s.url.scheme == 'https').toList();
      final audio =
          manifest.audioOnly.where((s) => s.url.scheme == 'https').toList();
      if (videos.isNotEmpty && audio.isNotEmpty) {
        videos.sort((a, b) => b.bitrate.compareTo(a.bitrate));
        audio.sort((a, b) => b.bitrate.compareTo(a.bitrate));
        return ResolvedVideo(videos.first.url, audio: audio.first.url);
      }
    } catch (_) {
      return null;
    } finally {
      youtube.close();
    }
    return null;
  }

  Future<ResolvedVideo?> _fastInvidiousRace(String videoId) async {
    final client = http.Client();
    try {
      // Dispara requisições simultâneas aos hosts mais rápidos
      final topHosts = _invidiousHosts.take(3);
      final futures = topHosts
          .map((host) => _fetchInvidiousHost(client, host, videoId))
          .toList();
      return await _firstSuccessful(futures);
    } finally {
      client.close();
    }
  }

  Future<ResolvedVideo?> _fetchInvidiousHost(
    http.Client client,
    String host,
    String videoId,
  ) async {
    try {
      final uri = Uri.https(host, '/api/v1/videos/$videoId');
      final response =
          await client.get(uri).timeout(const Duration(milliseconds: 2200));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! Map) return null;

      // 1. Muxed streams
      final muxed = _formatUrl(data['formatStreams'], host, [22, 18, 43, 36]);
      if (muxed != null) return ResolvedVideo(muxed);

      // 2. Playlist HLS
      final hls = _trustedUri(data['hlsUrl'], host);
      if (hls != null) return ResolvedVideo(hls);

      // 3. Streams adaptativos separados
      final video = _formatUrl(
          data['adaptiveFormats'], host, [136, 135, 134, 133, 137, 160]);
      final audio = _formatUrl(data['adaptiveFormats'], host, [140, 251, 171]);
      if (video != null && audio != null) {
        return ResolvedVideo(video, audio: audio);
      }

      // 4. Redirecionamento de versão direta
      final directVersion = Uri.https(host, '/latest_version', {
        'id': videoId,
        'itag': '18',
      });
      return ResolvedVideo(directVersion);
    } catch (_) {
      return null;
    }
  }

  Future<ResolvedVideo?> _fastPipedRace(String videoId) async {
    final client = http.Client();
    try {
      final topHosts = _pipedHosts.take(2);
      final futures = topHosts
          .map((host) => _fetchPipedHost(client, host, videoId))
          .toList();
      return await _firstSuccessful(futures);
    } finally {
      client.close();
    }
  }

  Future<ResolvedVideo?> _fetchPipedHost(
    http.Client client,
    String host,
    String videoId,
  ) async {
    try {
      final uri = Uri.https(host, '/streams/$videoId');
      final response =
          await client.get(uri).timeout(const Duration(milliseconds: 2200));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! Map) return null;

      final hls = data['hls'];
      if (hls is String && hls.startsWith('http')) {
        return ResolvedVideo(Uri.parse(hls));
      }

      final streams = data['videoStreams'];
      if (streams is List && streams.isNotEmpty) {
        for (final s in streams.whereType<Map>()) {
          if (s['videoOnly'] == false && s['url'] != null) {
            final streamUrl = '${s['url']}';
            if (streamUrl.startsWith('http')) {
              return ResolvedVideo(Uri.parse(streamUrl));
            }
          }
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<T?> _firstSuccessful<T>(List<Future<T?>> futures) async {
    if (futures.isEmpty) return null;
    final completer = Completer<T?>();
    var remaining = futures.length;

    for (final future in futures) {
      future.then((value) {
        if (value != null && !completer.isCompleted) {
          completer.complete(value);
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

  Uri? _formatUrl(Object? entries, String host, List<int> priorities) {
    if (entries is! List) return null;
    for (final itag in priorities) {
      for (final entry in entries.whereType<Map>()) {
        if (entry['itag'].toString() != '$itag') continue;
        final uri = _trustedUri(entry['url'], host);
        if (uri != null) return uri;
      }
    }
    return null;
  }

  Uri? _trustedUri(Object? value, String host) {
    if (value is! String || value.trim().isEmpty) return null;
    final trimmed = value.trim();

    if (trimmed.startsWith('/')) {
      return Uri.https(host, trimmed);
    }
    final parsed = Uri.tryParse(trimmed);
    if (parsed == null) return null;
    if (parsed.scheme == 'https' || parsed.scheme == 'http') {
      return parsed;
    }
    return null;
  }
}
