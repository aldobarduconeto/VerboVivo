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
      animation: Listenable.merge([_settings, _controller, _topicController]),
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
              final search = _buildSearchField(strings, isDense: inlineSearch);

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: colors.surface,
                  elevation: 0,
                  scrolledUnderElevation: 0.5,
                  toolbarHeight: 66,
                  titleSpacing: 18,
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.primary,
                              colors.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          size: 20,
                          color: colors.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          strings.appTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            fontSize: 20,
                          ),
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
                          preferredSize: const Size.fromHeight(56),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                            child: search,
                          ),
                        ),
                  actions: [
                    IconButton.filledTonal(
                      tooltip: _settings.tvMode
                          ? 'Desativar Modo TV'
                          : 'Modo TV & Gamepad',
                      isSelected: _settings.tvMode,
                      onPressed: () => _settings.setTvMode(!_settings.tvMode),
                      selectedIcon: const Icon(Icons.tv_rounded, size: 20),
                      icon: const Icon(Icons.tv_outlined, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: _settings.tvMode
                            ? colors.primaryContainer
                            : colors.surfaceContainerHigh.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      tooltip: 'Alternar tema',
                      onPressed: widget.onToggleTheme,
                      icon: Icon(
                        widget.dark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            colors.surfaceContainerHigh.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
                bottomNavigationBar:
                    _buildBottomBar(strings, colors, inlineSearch),
                body: SafeArea(
                  child: Row(
                    children: [
                      if (inlineSearch) ...[
                        _buildNavigationRail(strings, colors, constraints),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: colors.outlineVariant.withValues(alpha: 0.15),
                        ),
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

  Widget _buildSearchField(AppStrings strings, {bool isDense = false}) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      key: _searchFieldKey,
      controller: _topicController,
      focusNode: _topicFocusNode,
      maxLength: 280,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _onSearch(),
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        counterText: '',
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: isDense ? 10 : 12),
        hintText: strings.searchFieldHint,
        prefixIcon: Icon(Icons.search_rounded, size: 20, color: colors.primary),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_topicController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_rounded, size: 18),
                tooltip: 'Limpar',
                onPressed: () {
                  setState(() {
                    _topicController.clear();
                  });
                },
              ),
            IconButton(
              tooltip: strings.searchButton,
              onPressed: _onSearch,
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildBottomBar(
      AppStrings strings, ColorScheme colors, bool isLargeScreen) {
    final tvHint = _settings.tvMode
        ? Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.gamepad_rounded, size: 16, color: colors.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'D-pad: Navegar • A/OK: Selecionar • L1/R1: Abas • B: Voltar • Y: Modo TV',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
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
                color: colors.outlineVariant.withValues(alpha: 0.14),
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
                icon: Badge(
                  isLabelVisible: _settings.hasUpdateBadge,
                  smallSize: 8,
                  child: const Icon(Icons.settings_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: _settings.hasUpdateBadge,
                  smallSize: 8,
                  child: const Icon(Icons.settings_rounded),
                ),
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
            icon: Badge(
              isLabelVisible: _settings.hasUpdateBadge,
              smallSize: 8,
              child: const Icon(Icons.settings_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: _settings.hasUpdateBadge,
              smallSize: 8,
              child: const Icon(Icons.settings_rounded),
            ),
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
