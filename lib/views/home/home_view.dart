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
  final _searchFieldKey = GlobalKey();
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
        const SnackBar(
            content: Text('O tema deve ter no máximo 280 caracteres.')),
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
            _topicFocusNode.requestFocus();
          },
          onToggleTvMode: () => _settings.setTvMode(!_settings.tvMode),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final inlineSearch = constraints.maxWidth >= 720;
              final search = _buildSearchField(strings);

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: colors.surface,
                  toolbarHeight: 66,
                  titleSpacing: 20,
                  shape: Border(
                    bottom: BorderSide(color: colors.outlineVariant),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 20,
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          strings.appTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (inlineSearch) ...[
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 480),
                              child: search,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  bottom: inlineSearch
                      ? null
                      : PreferredSize(
                          preferredSize: const Size.fromHeight(60),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: search,
                          ),
                        ),
                  actions: [
                    IconButton(
                      tooltip: _settings.tvMode
                          ? 'Desativar Modo TV'
                          : 'Ativar Modo TV',
                      isSelected: _settings.tvMode,
                      onPressed: () => _settings.setTvMode(!_settings.tvMode),
                      selectedIcon: const Icon(Icons.tv_rounded),
                      icon: const Icon(Icons.tv_off_outlined),
                    ),
                    IconButton(
                      tooltip: 'Alternar tema',
                      onPressed: widget.onToggleTheme,
                      icon: Icon(
                        widget.dark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                bottomNavigationBar:
                    _buildBottomBar(strings, colors, inlineSearch),
                body: SafeArea(
                  child: Row(
                    children: [
                      if (inlineSearch) ...[
                        _buildNavigationRail(strings, colors, constraints),
                        const VerticalDivider(width: 1, thickness: 1),
                      ],
                      Expanded(
                        key: const ValueKey('main-content'),
                        child: _buildBodyContent(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchField(AppStrings strings) {
    return TextField(
      key: _searchFieldKey,
      controller: _topicController,
      focusNode: _topicFocusNode,
      maxLength: 280,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _onSearch(),
      decoration: InputDecoration(
        isDense: true,
        counterText: '',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        hintText: strings.searchFieldHint,
        labelText: strings.searchFieldLabel,
        suffixIcon: IconButton(
          tooltip: strings.searchButton,
          onPressed: _onSearch,
          icon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }

  Widget? _buildBottomBar(
      AppStrings strings, ColorScheme colors, bool isLargeScreen) {
    final tvHint = _settings.tvMode
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colors.surfaceContainerHighest.withValues(alpha: 0.95),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gamepad_rounded, size: 16, color: colors.primary),
                const SizedBox(width: 8),
                Flexible(
                    child: Text(
                  'D-pad: Navegar • A/OK: Selecionar • L1/R1: Abas • B: Voltar • Y: Modo TV',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurfaceVariant,
                  ),
                )),
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
        backgroundColor: colors.surface,
        scrollable: true,
        indicatorColor: colors.primaryContainer,
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
