import 'package:flutter/material.dart';

class AccentColorOption {
  const AccentColorOption({
    required this.name,
    required this.color,
    required this.darkColor,
    this.isHighContrast = false,
  });

  final String name;
  final Color color;
  final Color darkColor;
  final bool isHighContrast;
}

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.accentColorIndex = 0,
    this.language = 'pt',
    this.bibleTranslation = 'ACF11',
    this.fontSize = 18.0,
    this.highContrast = false,
    this.dailyReflectionReminder = false,
    this.tvMode = false,
  });

  final ThemeMode themeMode;
  final int accentColorIndex;
  final String language;
  final String bibleTranslation;
  final double fontSize;
  final bool highContrast;
  final bool dailyReflectionReminder;
  final bool tvMode;

  AppSettings copyWith({
    ThemeMode? themeMode,
    int? accentColorIndex,
    String? language,
    String? bibleTranslation,
    double? fontSize,
    bool? highContrast,
    bool? dailyReflectionReminder,
    bool? tvMode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      accentColorIndex: accentColorIndex ?? this.accentColorIndex,
      language: language ?? this.language,
      bibleTranslation: bibleTranslation ?? this.bibleTranslation,
      fontSize: fontSize ?? this.fontSize,
      highContrast: highContrast ?? this.highContrast,
      dailyReflectionReminder:
          dailyReflectionReminder ?? this.dailyReflectionReminder,
      tvMode: tvMode ?? this.tvMode,
    );
  }
}
