import 'package:flutter/material.dart';
import '../../controllers/settings_controller.dart';
import '../../services/app_localizations.dart';
import '../../services/bible_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key, this.isEmbedded = false});

  final bool isEmbedded;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _settings = SettingsController.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settings,
      builder: (context, _) {
        final strings = AppLocalizations.of(_settings.language);
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        final body = ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          children: [
            // 1. TEMA E MODO DE EXIBIÇÃO
            _buildSectionHeader(
              icon: Icons.brightness_6_rounded,
              title: strings.themeSection,
              colors: colors,
            ),
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SegmentedButton<ThemeMode>(
                        segments: [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            icon: const Icon(Icons.brightness_auto_rounded),
                            label: Text(strings.themeSystem),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            icon: const Icon(Icons.light_mode_rounded),
                            label: Text(strings.themeLight),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            icon: const Icon(Icons.dark_mode_rounded),
                            label: Text(strings.themeDark),
                          ),
                        ],
                        selected: {_settings.themeMode},
                        onSelectionChanged: (selected) {
                          _settings.setThemeMode(selected.first);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 2. MODO TV E CONTROLES REMOTOS / GAMEPAD
              _buildSectionHeader(
                icon: Icons.tv_rounded,
                title: strings.tvMode,
                colors: colors,
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(strings.tvMode),
                        subtitle: Text(strings.tvModeDesc),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.tv_rounded,
                              color: colors.onPrimaryContainer),
                        ),
                        value: _settings.tvMode,
                        onChanged: (val) => _settings.setTvMode(val),
                      ),
                      const Divider(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.gamepad_rounded, size: 18, color: colors.primary),
                                const SizedBox(width: 8),
                                const Text(
                                  'Guia de Comandos TV & Gamepad',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '• D-pad / Setas: Navegação de foco com ampliação visual\n'
                              '• Enter / Botão A / OK: Abrir ou reproduzir\n'
                              '• Botão B / Esc / Voltar: Retornar à tela anterior\n'
                              '• L1 / R1 / PageUp / PageDown: Alternar abas rapidamente\n'
                              '• Botão X / F3: Focar barra de pesquisa\n'
                              '• Botão Y / F4: Alternar Modo TV',
                              style: TextStyle(fontSize: 12, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. PALETA DE CORES E CONTRASTE
              _buildSectionHeader(
                icon: Icons.palette_outlined,
                title: strings.colorSection,
                colors: colors,
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cor de Destaque',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(
                          SettingsController.accentColors.length,
                          (index) {
                            final option = SettingsController.accentColors[index];
                            final isSelected = _settings.accentColorIndex == index;
                            final isDark = theme.brightness == Brightness.dark;
                            final colorToDisplay =
                                isDark ? option.darkColor : option.color;

                            return InkWell(
                              onTap: () => _settings.setAccentColorIndex(index),
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: colorToDisplay,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? colors.onSurface
                                        : Colors.transparent,
                                    width: isSelected ? 3 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: colorToDisplay.withValues(alpha: 0.5),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          )
                                        ]
                                      : null,
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: option.isHighContrast && isDark
                                            ? Colors.black
                                            : Colors.white,
                                        size: 26,
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _settings.currentAccent.name,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 28),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(strings.highContrastMode),
                        subtitle: const Text(
                            'Reforça linhas, bordas e contraste para máxima legibilidade.'),
                        value: _settings.highContrast,
                        onChanged: (val) => _settings.setHighContrast(val),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. IDIOMA DO APLICATIVO
              _buildSectionHeader(
                icon: Icons.language_rounded,
                title: strings.languageSection,
                colors: colors,
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    _buildRadioLanguageTile('pt', 'Português (Brasil)', '🇧🇷'),
                    const Divider(height: 1),
                    _buildRadioLanguageTile('en', 'English (US)', '🇺🇸'),
                    const Divider(height: 1),
                    _buildRadioLanguageTile('es', 'Español', '🇪🇸'),
                  ],
                ),
              ),

              // 4. LEITURA BÍBLICA
              _buildSectionHeader(
                icon: Icons.menu_book_rounded,
                title: strings.bibleSection,
                colors: colors,
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.preferredTranslation,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _settings.bibleTranslation,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'ACF11',
                            child: Text('Almeida Corrigida Fiel (ACF) - Padrão'),
                          ),
                          DropdownMenuItem(
                            value: 'ARA',
                            child: Text('Almeida Revista e Atualizada (ARA)'),
                          ),
                          DropdownMenuItem(
                            value: 'ARC09',
                            child: Text('Almeida Revista e Corrigida (ARC)'),
                          ),
                          DropdownMenuItem(
                            value: 'WEB',
                            child: Text('World English Bible (WEB - Inglês)'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) _settings.setBibleTranslation(val);
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            strings.defaultFontSize,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${_settings.fontSize.toInt()} pt',
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        min: 14,
                        max: 30,
                        divisions: 8,
                        label: '${_settings.fontSize.toInt()} pt',
                        value: _settings.fontSize,
                        onChanged: (val) => _settings.setFontSize(val),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          'Exemplo: "O Senhor é o meu pastor; nada me faltará."',
                          style: TextStyle(
                            fontSize: _settings.fontSize,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. CACHE E ARMAZENAMENTO
              _buildSectionHeader(
                icon: Icons.storage_rounded,
                title: strings.cacheSection,
                colors: colors,
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              strings.clearBibleCache,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${BibleService.cachedChapterCount} capítulos armazenados em memória.',
                              style: TextStyle(
                                  color: colors.onSurfaceVariant, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          BibleService.clearCache();
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(strings.cacheClearedSuccess),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.cleaning_services_rounded, size: 18),
                        label: const Text('Limpar'),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. LEMBRETE E REFLEXÃO
              _buildSectionHeader(
                icon: Icons.notifications_none_rounded,
                title: 'Notificações & Hábitos',
                colors: colors,
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: SwitchListTile(
                  title: Text(strings.dailyReminder),
                  subtitle: Text(strings.dailyReminderDesc),
                  value: _settings.dailyReflectionReminder,
                  onChanged: (val) => _settings.setDailyReflectionReminder(val),
                ),
              ),

              // 7. SOBRE O APLICATIVO
              _buildSectionHeader(
                icon: Icons.info_outline_rounded,
                title: strings.aboutSection,
                colors: colors,
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 30),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.auto_stories_rounded,
                                color: colors.onPrimaryContainer, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.appTitle,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  strings.appVersion,
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.appDescription,
                        style: TextStyle(
                            color: colors.onSurfaceVariant, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.credits,
                        style: TextStyle(color: colors.outline, fontSize: 11),
                      ),
                      const Divider(height: 24),
                      TextButton.icon(
                        style: TextButton.styleFrom(foregroundColor: colors.error),
                        onPressed: () => _confirmReset(context, strings),
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: Text(strings.resetSettings),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

        if (widget.isEmbedded) {
          return body;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(strings.settingsTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: body,
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required ColorScheme colors,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioLanguageTile(String code, String name, String flag) {
    final isSelected = _settings.language == code;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 22)),
      title: Text(name,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () => _settings.setLanguage(code),
    );
  }

  Future<void> _confirmReset(BuildContext context, AppStrings strings) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(strings.resetSettings),
        content: Text(strings.resetSettingsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(strings.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _settings.resetToDefaults();
    }
  }
}

// Backwards compatibility alias
typedef SettingsScreen = SettingsView;
