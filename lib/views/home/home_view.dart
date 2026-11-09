import 'package:flutter/material.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../services/app_localizations.dart';
import '../../widgets/tv_focusable.dart';
import '../../widgets/tv_remote_scope.dart';
import '../angel/angel_view.dart';
import '../bible/bible_view.dart';
import '../bible_study/bible_study_view.dart';
import '../settings/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.onToggleTheme,
    required this.dark,
    this.controller,
  });

  final VoidCallback onToggleTheme;
  final bool dark;
  final HomeController? controller;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController _controller;
  final _topicController = TextEditingController();
  final _topicFocusNode = FocusNode();
  final _settings = SettingsController.instance;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? HomeController();
  }

  @override
  void dispose() {
    _topicController.dispose();
    _topicFocusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSearch() {
    final query = _topicController.text;
    final strings = AppLocalizations.of(_settings.language);

    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.searchFieldHint)),
      );
      return;
    }
    if (query.length > 280) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O tema deve ter no máximo 280 caracteres.')),
      );
      return;
    }

    final success = _controller.searchCustomTopic(query);
    if (success) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_settings, _controller]),
      builder: (context, _) {
        final strings = AppLocalizations.of(_settings.language);
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return TvRemoteScope(
          onNextTab: () {
            if (_controller.mainTab == 0 && _controller.confirmed) {
              _controller.nextTab();
            } else {
              _controller.nextMainTab();
            }
          },
          onPrevTab: () {
            if (_controller.mainTab == 0 && _controller.confirmed) {
              _controller.previousTab();
            } else {
              _controller.previousMainTab();
            }
          },
          onBack: () {
            if (_topicController.text.isNotEmpty) {
              _topicController.clear();
            } else if (_controller.mainTab != 0) {
              _controller.setMainTab(0);
            }
          },
          onSearchRequested: () {
            _controller.setMainTab(0);
            _topicFocusNode.requestFocus();
          },
          onToggleTvMode: () => _settings.setTvMode(!_settings.tvMode),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLargeScreen = constraints.maxWidth >= 720 || _settings.tvMode;

              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 16,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [colors.primary, colors.tertiary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            _controller.mainTab == 1
                                ? Icons.menu_book_rounded
                                : _controller.mainTab == 2
                                    ? Icons.movie_filter_rounded
                                    : _controller.mainTab == 3
                                        ? Icons.settings_rounded
                                        : Icons.auto_stories_rounded,
                            color: colors.onPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        strings.appTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 19,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (_settings.tvMode) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tv_rounded, size: 14, color: colors.onPrimary),
                              const SizedBox(width: 5),
                              Text(
                                'MODO TV',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: colors.onPrimary,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    IconButton.filledTonal(
                      tooltip: _settings.tvMode ? 'Desativar Modo TV' : 'Ativar Modo TV',
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _settings.setTvMode(!_settings.tvMode),
                      icon: Icon(
                        _settings.tvMode ? Icons.tv_rounded : Icons.tv_off_outlined,
                        color: _settings.tvMode ? colors.primary : null,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton.filledTonal(
                      tooltip: 'Alternar tema',
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: widget.onToggleTheme,
                      icon: Icon(
                        widget.dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        size: 20,
                      ),
                    ),
                    if (!isLargeScreen && _controller.mainTab != 3) ...[
                      const SizedBox(width: 4),
                      IconButton.filledTonal(
                        tooltip: strings.settingsTitle,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _controller.setMainTab(3),
                        icon: const Icon(Icons.settings_outlined, size: 20),
                      ),
                    ],
                    const SizedBox(width: 12),
                  ],
                ),
                bottomNavigationBar: _buildBottomBar(strings, colors, isLargeScreen),
                body: SafeArea(
                  child: isLargeScreen
                      ? Row(
                          children: [
                            _buildNavigationRail(strings, colors, constraints),
                            const VerticalDivider(width: 1, thickness: 1),
                            Expanded(child: _buildBodyContent()),
                          ],
                        )
                      : _buildBodyContent(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget? _buildBottomBar(AppStrings strings, ColorScheme colors, bool isLargeScreen) {
    final tvHint = _settings.tvMode
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colors.surfaceContainerHighest.withValues(alpha: 0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gamepad_rounded, size: 16, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  'D-pad: Navegar • A/OK: Selecionar • L1/R1: Abas • B: Voltar • Y: Modo TV',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        : null;

    if (isLargeScreen) {
      return tvHint;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tvHint != null) tvHint,
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colors.outlineVariant.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _controller.mainTab,
            onDestinationSelected: _controller.setMainTab,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.auto_stories_outlined),
                selectedIcon: const Icon(Icons.auto_stories_rounded),
                label: strings.tabBibleStudy,
              ),
              NavigationDestination(
                icon: const Icon(Icons.menu_book_outlined),
                selectedIcon: const Icon(Icons.menu_book_rounded),
                label: strings.tabBible,
              ),
              NavigationDestination(
                icon: const Icon(Icons.movie_filter_outlined),
                selectedIcon: const Icon(Icons.movie_filter_rounded),
                label: strings.tabAngel,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings_rounded),
                label: strings.settingsTitle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationRail(
    AppStrings strings,
    ColorScheme colors,
    BoxConstraints constraints,
  ) {
    final isExtended = constraints.maxWidth >= 960 && !_settings.tvMode;

    return TvFocusable(
      onPressed: () {},
      borderRadius: BorderRadius.zero,
      child: NavigationRail(
        selectedIndex: _controller.mainTab,
        onDestinationSelected: _controller.setMainTab,
        extended: isExtended,
        minWidth: _settings.tvMode ? 90 : 72,
        labelType: isExtended
            ? NavigationRailLabelType.none
            : NavigationRailLabelType.all,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.auto_stories_outlined),
            selectedIcon: const Icon(Icons.auto_stories_rounded),
            label: Text(strings.tabBibleStudy),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book_rounded),
            label: Text(strings.tabBible),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.movie_filter_outlined),
            selectedIcon: const Icon(Icons.movie_filter_rounded),
            label: Text(strings.tabAngel),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: Text(strings.settingsTitle),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    return IndexedStack(
      index: _controller.mainTab,
      children: [
        BibleStudyView(
          controller: _controller,
          settings: _settings,
          topicController: _topicController,
          topicFocusNode: _topicFocusNode,
          onSearch: _onSearch,
          onNavigateToAngel: () => _controller.setMainTab(2),
        ),
        const BibleView(),
        AngelView(
          controller: _controller,
          settings: _settings,
        ),
        const SettingsView(isEmbedded: true),
      ],
    );
  }
}

// Backwards compatibility alias
typedef HomeScreen = HomeView;
