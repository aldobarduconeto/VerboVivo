import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Consulta GitHub Releases e encaminha para o pacote da plataforma atual.
/// A instalação continua sendo feita pelo sistema operacional ou pela loja.
class AppUpdateService {
  AppUpdateService._();

  static const _releasesUrl =
      'https://github.com/aldobarduconeto/VerboVivo/releases/latest';
  static const _latestReleaseApi =
      'https://api.github.com/repos/aldobarduconeto/VerboVivo/releases/latest';
  static const _allReleasesApi =
      'https://api.github.com/repos/aldobarduconeto/VerboVivo/releases?per_page=5';

  static http.Client? _defaultClient;
  static http.Client get _sharedClient => _defaultClient ??= http.Client();

  static UpdateCheckResult? _cachedResult;
  static DateTime? _cacheExpiry;
  static Future<UpdateCheckResult>? _inFlightCheck;

  /// Limpa o cache de verificação de atualização.
  static void clearCache() {
    _cachedResult = null;
    _cacheExpiry = null;
  }

  /// Verifica se há atualizações disponíveis no GitHub Releases.
  ///
  /// Usa cache inteligente de 15 minutos para evitar esgotar a cota da API do GitHub.
  /// Pode ser forçado com [forceRefresh] = true.
  static Future<UpdateCheckResult> checkForUpdate({
    bool forceRefresh = false,
    http.Client? client,
  }) {
    if (!forceRefresh &&
        _cachedResult != null &&
        _cacheExpiry != null &&
        DateTime.now().isBefore(_cacheExpiry!)) {
      return Future.value(_cachedResult!);
    }

    if (_inFlightCheck != null && !forceRefresh) {
      return _inFlightCheck!;
    }

    final future = _executeCheck(client: client);
    _inFlightCheck = future;
    return future.whenComplete(() => _inFlightCheck = null);
  }

  /// Verificação silenciosa para ser executada em segundo plano na inicialização.
  /// Retorna null em caso de falha de conexão sem lançar exceções.
  static Future<UpdateCheckResult?> checkForUpdateSilent({
    http.Client? client,
  }) async {
    try {
      return await checkForUpdate(client: client);
    } catch (_) {
      return null;
    }
  }

  static Future<UpdateCheckResult> _executeCheck({http.Client? client}) async {
    final package = await PackageInfo.fromPlatform();
    final httpClient = client ?? _sharedClient;
    final headers = const {
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      'User-Agent': 'VerboVivo-App',
    };

    Map<String, dynamic>? release;

    // 1. Tenta obter a release mais recente marcada como 'latest'
    try {
      final response = await httpClient
          .get(Uri.parse(_latestReleaseApi), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        release = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      }
    } catch (_) {}

    // 2. Se a rota latest falhar (ex: pre-release ou 404), tenta a lista de releases recentes
    if (release == null) {
      try {
        final response = await httpClient
            .get(Uri.parse(_allReleasesApi), headers: headers)
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final list = jsonDecode(utf8.decode(response.bodyBytes));
          if (list is List && list.isNotEmpty) {
            for (final item in list.whereType<Map<String, dynamic>>()) {
              if (item['draft'] != true) {
                release = item;
                break;
              }
            }
          }
        }
      } catch (_) {}
    }

    if (release == null) {
      throw const FormatException('Não foi possível consultar as releases no momento.');
    }

    final latestVersion = (release['tag_name'] as String?)?.trim();
    final releaseUrl = _githubUri(release['html_url'] as String?);
    if (latestVersion == null || latestVersion.isEmpty || releaseUrl == null) {
      throw const FormatException('A release publicada está incompleta.');
    }

    final releaseName = (release['name'] as String?)?.trim().isNotEmpty == true
        ? (release['name'] as String).trim()
        : 'Versão $latestVersion';

    final releaseNotes = (release['body'] as String?)?.trim() ?? '';
    DateTime? publishedAt;
    if (release['published_at'] != null) {
      publishedAt = DateTime.tryParse(release['published_at'].toString());
    }

    final rawAssets = (release['assets'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();

    final assets = rawAssets
        .map((asset) => ReleaseAsset(
              name: asset['name'] as String? ?? '',
              url: _githubUri(asset['browser_download_url'] as String?),
              sizeBytes: (asset['size'] as num?)?.toInt(),
              downloadCount: (asset['download_count'] as num?)?.toInt(),
            ))
        .where((asset) => asset.url != null)
        .toList();

    final asset = _assetForCurrentPlatform(assets);
    final updateAvailable = _compareVersions(latestVersion, package.version) > 0;

    final result = UpdateCheckResult(
      currentVersion: package.version,
      latestVersion: latestVersion,
      releaseTitle: releaseName,
      releaseNotes: releaseNotes,
      publishedAt: publishedAt,
      releaseUrl: releaseUrl,
      asset: asset,
      allAssets: assets,
      updateAvailable: updateAvailable,
      platform: _platformName,
      storeManaged: defaultTargetPlatform == TargetPlatform.iOS,
    );

    _cachedResult = result;
    _cacheExpiry = DateTime.now().add(const Duration(minutes: 15));

    return result;
  }

  static Uri? _githubUri(String? value) {
    final uri = Uri.tryParse(value ?? '');
    if (uri == null || uri.scheme != 'https' || uri.host != 'github.com') {
      return null;
    }
    return uri;
  }

  /// Identifica o pacote mais adequado para a plataforma atual com heurística inteligente.
  static ReleaseAsset? _assetForCurrentPlatform(List<ReleaseAsset> assets) {
    if (kIsWeb || assets.isEmpty) return null;

    final target = defaultTargetPlatform;

    // 1. Tenta correspondência exata de nomes padronizados no CI
    final exact = _matchExactPlatform(target, assets);
    if (exact != null) return exact;

    // 2. Heurística resiliente por extensão e palavras-chave
    return _matchHeuristicPlatform(target, assets);
  }

  static ReleaseAsset? _matchExactPlatform(
      TargetPlatform platform, List<ReleaseAsset> assets) {
    late final String expected;
    switch (platform) {
      case TargetPlatform.android:
        expected = 'verbovivo-android.apk';
        break;
      case TargetPlatform.windows:
        expected = 'VerboVivo-Setup.exe';
        break;
      case TargetPlatform.macOS:
        expected = 'verbovivo-macos.dmg';
        break;
      case TargetPlatform.linux:
        expected = 'verbovivo-linux.deb';
        break;
      case TargetPlatform.iOS:
        expected = 'verbovivo-ios.ipa';
        break;
      case TargetPlatform.fuchsia:
        return null;
    }

    final lowerExpected = expected.toLowerCase();
    for (final asset in assets) {
      if (asset.name.toLowerCase() == lowerExpected) return asset;
    }
    return null;
  }

  static ReleaseAsset? _matchHeuristicPlatform(
      TargetPlatform platform, List<ReleaseAsset> assets) {
    switch (platform) {
      case TargetPlatform.android:
        return _firstMatching(assets, (name) => name.endsWith('.apk'));

      case TargetPlatform.windows:
        // Prefere executável com setup/installer, depois qualquer .exe, depois .msix, depois .zip
        return _firstMatching(assets, (name) => name.endsWith('.exe') && (name.contains('setup') || name.contains('installer'))) ??
            _firstMatching(assets, (name) => name.endsWith('.exe')) ??
            _firstMatching(assets, (name) => name.endsWith('.msix')) ??
            _firstMatching(assets, (name) => name.endsWith('.zip') && name.contains('win'));

      case TargetPlatform.macOS:
        return _firstMatching(assets, (name) => name.endsWith('.dmg')) ??
            _firstMatching(assets, (name) => name.endsWith('.pkg')) ??
            _firstMatching(assets, (name) => name.endsWith('.zip') && (name.contains('mac') || name.contains('darwin')));

      case TargetPlatform.linux:
        return _firstMatching(assets, (name) => name.endsWith('.deb')) ??
            _firstMatching(assets, (name) => name.endsWith('.appimage')) ??
            _firstMatching(assets, (name) => name.endsWith('.tar.gz') && name.contains('linux'));

      case TargetPlatform.iOS:
        return _firstMatching(assets, (name) => name.endsWith('.ipa'));

      case TargetPlatform.fuchsia:
        return null;
    }
  }

  static ReleaseAsset? _firstMatching(
      List<ReleaseAsset> assets, bool Function(String lowerName) predicate) {
    for (final asset in assets) {
      if (predicate(asset.name.toLowerCase())) {
        return asset;
      }
    }
    return null;
  }

  static String get _platformName {
    if (kIsWeb) return 'Web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }

  static int _compareVersions(String left, String right) {
    List<int> parts(String version) => version
        .trim()
        .replaceFirst(RegExp(r'^[vV]'), '')
        .split('+')
        .first
        .split('-')
        .first
        .split('.')
        .map((part) => int.tryParse(part) ?? 0)
        .toList();

    final a = parts(left);
    final b = parts(right);
    for (var i = 0; i < (a.length > b.length ? a.length : b.length); i++) {
      final comparison =
          (i < a.length ? a[i] : 0).compareTo(i < b.length ? b[i] : 0);
      if (comparison != 0) return comparison;
    }
    return 0;
  }

  static Future<bool> openUpdateChannel([Uri? url]) => launchUrl(
        url ?? Uri.parse(_releasesUrl),
        mode: LaunchMode.externalApplication,
      );
}

class ReleaseAsset {
  const ReleaseAsset({
    required this.name,
    required this.url,
    this.sizeBytes,
    this.downloadCount,
  });

  final String name;
  final Uri? url;
  final int? sizeBytes;
  final int? downloadCount;

  /// Formatação amigável do tamanho do arquivo (ex.: "24.5 MB")
  String get formattedSize {
    final bytes = sizeBytes;
    if (bytes == null || bytes <= 0) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class UpdateCheckResult {
  const UpdateCheckResult({
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseTitle,
    required this.releaseNotes,
    required this.publishedAt,
    required this.releaseUrl,
    required this.asset,
    required this.allAssets,
    required this.updateAvailable,
    required this.platform,
    required this.storeManaged,
  });

  final String currentVersion;
  final String latestVersion;
  final String releaseTitle;
  final String releaseNotes;
  final DateTime? publishedAt;
  final Uri releaseUrl;
  final ReleaseAsset? asset;
  final List<ReleaseAsset> allAssets;
  final bool updateAvailable;
  final String platform;
  final bool storeManaged;

  /// Data de publicação formatada de modo legível (DD/MM/AAAA)
  String? get formattedPublishedDate {
    final d = publishedAt;
    if (d == null) return null;
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$month/$year';
  }
}
