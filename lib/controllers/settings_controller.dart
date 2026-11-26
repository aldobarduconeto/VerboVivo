import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings_model.dart';
import '../services/app_update_service.dart';

export '../models/settings_model.dart';

class SettingsController extends ChangeNotifier {
  SettingsController._();
  static final SettingsController instance = SettingsController._();

  static const List<AccentColorOption> accentColors = [
    AccentColorOption(
      name: 'Esmeralda Bíblica',
      color: Color(0xFF25866E),
      darkColor: Color(0xFF2EB090),
    ),
    AccentColorOption(
      name: 'Azul Celestial',
      color: Color(0xFF1E6091),
      darkColor: Color(0xFF4EA8DE),
    ),
    AccentColorOption(
      name: 'Púrpura Real',
      color: Color(0xFF6B2D8C),
      darkColor: Color(0xFFA663CC),
    ),
    AccentColorOption(
      name: 'Âmbar do Deserto',
      color: Color(0xFFB5651D),
      darkColor: Color(0xFFE08D3C),
    ),
    AccentColorOption(
      name: 'Carmesim Sagrado',
      color: Color(0xFF9E2A2B),
      darkColor: Color(0xFFD64545),
    ),
    AccentColorOption(
      name: 'Alto Contraste',
      color: Color(0xFF000000),
      darkColor: Color(0xFFFFFFFF),
      isHighContrast: true,
    ),
  ];

  ThemeMode _themeMode = ThemeMode.dark;
  int _accentColorIndex = 0;
  String _language = 'pt';
  String _bibleTranslation = 'ACF11';
  double _fontSize = 18.0;
  bool _highContrast = false;
  bool _dailyReflectionReminder = false;
  bool _tvMode = false;
  bool _autoCheckUpdates = true;
  UpdateCheckResult? _latestUpdate;
  bool _hasUpdateBadge = false;
  bool _isCheckingUpdate = false;
  DateTime? _lastUpdateCheck;
  bool _isLoaded = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  int get accentColorIndex => _accentColorIndex;
  AccentColorOption get currentAccent =>
      accentColors[_accentColorIndex.clamp(0, accentColors.length - 1)];
  String get language => _language;
  String get bibleTranslation => _bibleTranslation;
  double get fontSize => _fontSize;
  bool get highContrast => _highContrast;
  bool get dailyReflectionReminder => _dailyReflectionReminder;
  bool get tvMode => _tvMode;
  bool get autoCheckUpdates => _autoCheckUpdates;
  UpdateCheckResult? get latestUpdate => _latestUpdate;
  bool get hasUpdateBadge => _hasUpdateBadge;
  bool get isCheckingUpdate => _isCheckingUpdate;
  DateTime? get lastUpdateCheck => _lastUpdateCheck;
  bool get isLoaded => _isLoaded;

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final modeIndex = prefs.getInt('theme_mode');
      if (modeIndex != null && modeIndex >= 0 && modeIndex < ThemeMode.values.length) {
        _themeMode = ThemeMode.values[modeIndex];
      } else {
        final legacyDark = prefs.getBool('dark_theme');
        if (legacyDark != null) {
          _themeMode = legacyDark ? ThemeMode.dark : ThemeMode.light;
        }
      }

      _accentColorIndex = (prefs.getInt('accent_color_index') ?? 0)
          .clamp(0, accentColors.length - 1);
      _language = prefs.getString('app_language') ?? 'pt';
      _bibleTranslation = prefs.getString('bible_translation') ?? 'ACF11';
      _fontSize = (prefs.getDouble('bible_font_size') ?? 18.0).clamp(14.0, 32.0);
      _highContrast = prefs.getBool('high_contrast') ?? false;
      _dailyReflectionReminder = prefs.getBool('daily_reminder') ?? false;
      _tvMode = prefs.getBool('tv_mode') ?? false;
      _autoCheckUpdates = prefs.getBool('auto_check_updates') ?? true;

      final lastCheckEpoch = prefs.getInt('last_update_check_epoch');
      if (lastCheckEpoch != null) {
        _lastUpdateCheck = DateTime.fromMillisecondsSinceEpoch(lastCheckEpoch);
      }

      _isLoaded = true;
      notifyListeners();
    } catch (_) {
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Verifica silenciosamente se há atualizações na inicialização caso a opção esteja ativa.
  Future<void> checkUpdateOnStartup() async {
    if (!_autoCheckUpdates) return;

    // Throttle de 6 horas para verificação automática de inicialização
    if (_lastUpdateCheck != null &&
        DateTime.now().difference(_lastUpdateCheck!).inHours < 6) {
      return;
    }

    try {
      final result = await AppUpdateService.checkForUpdateSilent();
      if (result != null) {
        _latestUpdate = result;
        _lastUpdateCheck = DateTime.now();
        if (result.updateAvailable) {
          _hasUpdateBadge = true;
        }
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
          'last_update_check_epoch',
          _lastUpdateCheck!.millisecondsSinceEpoch,
        );
      }
    } catch (_) {}
  }

  Future<UpdateCheckResult> checkForUpdatesManually() async {
    _isCheckingUpdate = true;
    notifyListeners();
    try {
      final result = await AppUpdateService.checkForUpdate(forceRefresh: true);
      _latestUpdate = result;
      _lastUpdateCheck = DateTime.now();
      _hasUpdateBadge = result.updateAvailable;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'last_update_check_epoch',
        _lastUpdateCheck!.millisecondsSinceEpoch,
      );

      return result;
    } finally {
      _isCheckingUpdate = false;
      notifyListeners();
    }
  }

  void dismissUpdateBadge() {
    if (_hasUpdateBadge) {
      _hasUpdateBadge = false;
      notifyListeners();
    }
  }

  Future<void> setAutoCheckUpdates(bool enabled) async {
    if (_autoCheckUpdates == enabled) return;
    _autoCheckUpdates = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_check_updates', enabled);
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', mode.index);
      await prefs.setBool('dark_theme', mode == ThemeMode.dark);
    } catch (_) {}
  }

  Future<void> setAccentColorIndex(int index) async {
    final clamped = index.clamp(0, accentColors.length - 1);
    if (_accentColorIndex == clamped) return;
    _accentColorIndex = clamped;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('accent_color_index', clamped);
    } catch (_) {}
  }

  Future<void> setHighContrast(bool enabled) async {
    if (_highContrast == enabled) return;
    _highContrast = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('high_contrast', enabled);
    } catch (_) {}
  }

  Future<void> setLanguage(String lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', lang);
    } catch (_) {}
  }

  Future<void> setBibleTranslation(String translation) async {
    if (_bibleTranslation == translation) return;
    _bibleTranslation = translation;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('bible_translation', translation);
    } catch (_) {}
  }

  Future<void> setFontSize(double size) async {
    final clamped = size.clamp(14.0, 32.0);
    if (_fontSize == clamped) return;
    _fontSize = clamped;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('bible_font_size', clamped);
    } catch (_) {}
  }

  Future<void> setDailyReflectionReminder(bool enabled) async {
    if (_dailyReflectionReminder == enabled) return;
    _dailyReflectionReminder = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('daily_reminder', enabled);
    } catch (_) {}
  }

  Future<void> setTvMode(bool enabled) async {
    if (_tvMode == enabled) return;
    _tvMode = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tv_mode', enabled);
    } catch (_) {}
  }

  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.dark;
    _accentColorIndex = 0;
    _language = 'pt';
    _bibleTranslation = 'ACF11';
    _fontSize = 18.0;
    _highContrast = false;
    _dailyReflectionReminder = false;
    _tvMode = false;
    _autoCheckUpdates = true;
    _latestUpdate = null;
    _hasUpdateBadge = false;
    _lastUpdateCheck = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (_) {}
  }
}

// Typedef for backwards compatibility
typedef AppSettingsService = SettingsController;
