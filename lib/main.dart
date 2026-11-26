import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

import 'controllers/devotional_controller.dart';
import 'controllers/journal_controller.dart';
import 'controllers/reading_library_controller.dart';
import 'controllers/reading_plan_controller.dart';
import 'controllers/settings_controller.dart';
import 'views/home/home_view.dart';
import 'widgets/desktop_window_frame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  if (isDesktopWindow) {
    await windowManager.ensureInitialized();
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setMinimumSize(const Size(360, 480));
  }
  await Future.wait([
    SettingsController.instance.loadSettings(),
    ReadingLibraryController.instance.load(),
    ReadingPlanController.instance.load(),
    DevotionalController.instance.load(),
    JournalController.instance.load(),
  ]);
  runApp(const VerboVivoApp());

  // Verificação não bloqueante de atualizações em segundo plano
  SettingsController.instance.checkUpdateOnStartup();
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
          builder: (context, child) =>
              isDesktopWindow ? DesktopWindowFrame(child: child!) : child!,
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
      final baseColors = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      );
      colors = isDark
          ? baseColors.copyWith(
              surface: const Color(0xFF13181F),
              surfaceContainerLow: const Color(0xFF171E26),
              surfaceContainer: const Color(0xFF1B232D),
              surfaceContainerHigh: const Color(0xFF212A36),
              surfaceContainerHighest: const Color(0xFF283341),
            )
          : baseColors.copyWith(
              surface: const Color(0xFFFFFFFF),
              surfaceContainerLowest: const Color(0xFFFFFFFF),
              surfaceContainerLow: const Color(0xFFF8F9FA),
              surfaceContainer: const Color(0xFFF1F3F5),
              surfaceContainerHigh: const Color(0xFFEAEDF1),
              surfaceContainerHighest: const Color(0xFFE2E6EA),
            );
    }

    final bg = isDark ? const Color(0xFF0D1117) : const Color(0xFFF8F9FA);

    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(
        color: settings.highContrast
            ? colors.onSurface
            : colors.outlineVariant.withValues(alpha: isDark ? 0.16 : 0.35),
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
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: settings.highContrast ? 2 : (isDark ? 0 : 0.5),
        shadowColor: Colors.black.withValues(alpha: isDark ? 0 : 0.06),
        color: settings.highContrast
            ? colors.surface
            : (isDark ? colors.surfaceContainerLow : Colors.white),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: settings.highContrast
              ? BorderSide(color: colors.outline, width: 1.5)
              : BorderSide(
                  color: colors.outlineVariant
                      .withValues(alpha: isDark ? 0.14 : 0.28),
                  width: 1,
                ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF12161D) : Colors.white,
        elevation: 0,
        height: 68,
        indicatorColor: colors.primaryContainer.withValues(alpha: 0.9),
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(
            color: colors.outlineVariant.withValues(alpha: isDark ? 0.25 : 0.45),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(
          color: colors.outlineVariant.withValues(alpha: isDark ? 0.2 : 0.35),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        backgroundColor: colors.surface,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant.withValues(alpha: isDark ? 0.14 : 0.24),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? colors.surfaceContainer : colors.surfaceContainerHigh,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
