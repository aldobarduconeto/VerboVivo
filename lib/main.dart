import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'controllers/settings_controller.dart';
import 'views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await SettingsController.instance.loadSettings();
  runApp(const VerboVivoApp());
}

class VerboVivoApp extends StatelessWidget {
  const VerboVivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController.instance;

    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        final isDark = settings.themeMode == ThemeMode.dark;

        return MaterialApp(
          title: 'VerboVivo',
          debugShowCheckedModeBanner: false,
          themeMode: settings.themeMode,
          theme: _buildTheme(Brightness.light, settings),
          darkTheme: _buildTheme(Brightness.dark, settings),
          home: HomeScreen(
            onToggleTheme: () {
              final newMode = settings.themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
              settings.setThemeMode(newMode);
            },
            dark: isDark,
          ),
        );
      },
    );
  }

  ThemeData _buildTheme(Brightness brightness, SettingsController settings) {
    final accent = settings.currentAccent;
    final isDark = brightness == Brightness.dark;
    final seedColor = isDark ? accent.darkColor : accent.color;

    ColorScheme colors;
    if (settings.highContrast || accent.isHighContrast) {
      colors = isDark
          ? const ColorScheme.dark(
              primary: Color(0xFF64D2FF),
              onPrimary: Colors.black,
              primaryContainer: Color(0xFF004A77),
              onPrimaryContainer: Colors.white,
              surface: Color(0xFF000000),
              onSurface: Color(0xFFFFFFFF),
              surfaceContainer: Color(0xFF161616),
              surfaceContainerHighest: Color(0xFF262626),
              outline: Color(0xFFFFFFFF),
              outlineVariant: Color(0xFF888888),
            )
          : const ColorScheme.light(
              primary: Color(0xFF004085),
              onPrimary: Colors.white,
              primaryContainer: Color(0xFFCCE5FF),
              onPrimaryContainer: Colors.black,
              surface: Color(0xFFFFFFFF),
              onSurface: Color(0xFF000000),
              surfaceContainer: Color(0xFFF2F2F2),
              surfaceContainerHighest: Color(0xFFE5E5E5),
              outline: Color(0xFF000000),
              outlineVariant: Color(0xFF555555),
            );
    } else {
      colors = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      );
    }

    final bg = isDark ? const Color(0xFF0C1014) : const Color(0xFFF7F9FC);

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: settings.highContrast
            ? colors.onSurface
            : colors.outlineVariant.withValues(alpha: 0.25),
        width: settings.highContrast ? 2.0 : 1.0,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: settings.highContrast ? colors.surface : bg,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: colors.onSurface,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: settings.highContrast ? 2 : 0,
        color: isDark ? const Color(0xFF141A22) : Colors.white,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: settings.highContrast
              ? BorderSide(color: colors.outline, width: 1.5)
              : BorderSide(
                  color: colors.outlineVariant.withValues(alpha: isDark ? 0.12 : 0.35),
                  width: 1,
                ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF10151C) : Colors.white,
        elevation: 0,
        height: 68,
        indicatorColor: colors.primary.withValues(alpha: isDark ? 0.22 : 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? colors.primary : colors.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? colors.primary : colors.onSurfaceVariant,
            size: 22,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.4)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? const Color(0xFF171E28)
            : const Color(0xFFEEF2F6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(
          borderSide: BorderSide(
            color: colors.primary,
            width: settings.highContrast ? 3.0 : 2.0,
          ),
        ),
      ),
    );
  }
}
