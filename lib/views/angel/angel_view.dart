import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../models/angel_model.dart';
import '../../services/app_localizations.dart';
import '../../services/youtube_stream_service.dart';
import '../../widgets/responsive_media_grid.dart';
import '../../widgets/tv_focusable.dart';
import '../home/widgets/angel_card.dart';
import '../player/player_view.dart';

class AngelView extends StatefulWidget {
  const AngelView({
    super.key,
    required this.controller,
    required this.settings,
  });

  final HomeController controller;
  final SettingsController settings;

  @override
  State<AngelView> createState() => _AngelViewState();
}

class _AngelViewState extends State<AngelView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.controller.angelSearchQuery;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prewarmAngelStreams();
    });
  }

  void _prewarmAngelStreams() {
    final items = widget.controller.getAngelItems();
    for (final item in items.take(4)) {
      final sid = item.streamId;
      if (sid != null && sid.length == 11) {
        unawaited(const YouTubeStreamService().preload(sid));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String val) {
    widget.controller.setAngelSearchQuery(val);
  }

  void _openAngelItem(AngelMediaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerView(video: item.toVideoItem()),
      ),
    );
  }

  Future<void> _openExternalAngel() async {
    final uri = Uri.parse('https://www.angel.com/pt-BR');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(widget.settings.language);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final items = widget.controller.getAngelItems();
    final featured = widget.controller.featuredAngelItem;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // Hero Banner Institucional da Angel Studios
        Card(
          elevation: widget.settings.highContrast ? 2 : 1,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F3B32),
                  Color(0xFF08261F),
                ],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4CA83),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'ANGEL.COM/PT-BR',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E301F),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_open_rounded, size: 14, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            strings.angelFreeBadge,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  strings.angelSectionTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.angelNotice,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFDBEEE6),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    TvFocusable(
                      onPressed: () => _openAngelItem(featured),
                      borderRadius: BorderRadius.circular(14),
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF4CA83),
                          foregroundColor: const Color(0xFF1E301F),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        onPressed: () => _openAngelItem(featured),
                        icon: const Icon(Icons.play_arrow_rounded, size: 22),
                        label: Text(
                          'Assistir Destaque: ${featured.seriesTitle}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TvFocusable(
                      onPressed: _openExternalAngel,
                      borderRadius: BorderRadius.circular(14),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFDBEEE6), width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        ),
                        onPressed: _openExternalAngel,
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('Visitar angel.com/pt-BR'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Barra de Busca de Conteúdos da Angel Studios
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Pesquise produções (ex: The Chosen, Davi, Bonhoeffer, Cabrini)...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
            filled: true,
            fillColor: colors.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),

        // Filtro de Categorias em Chips Horizontais
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.controller.angelCategories.map((cat) {
              final isSelected = widget.controller.selectedAngelCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TvFocusable(
                  onPressed: () => widget.controller.setAngelCategory(cat),
                  borderRadius: BorderRadius.circular(20),
                  focusedScale: widget.settings.tvMode ? 1.08 : 1.04,
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        fontSize: widget.settings.tvMode ? 14 : 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => widget.controller.setAngelCategory(cat),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Grade de Conteúdos da Angel Studios
        if (items.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(Icons.movie_filter_outlined, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Nenhum conteúdo encontrado para o termo pesquisado nesta categoria.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                      widget.controller.setAngelCategory('Todos');
                    },
                    child: const Text('Limpar filtros e ver catálogo completo'),
                  ),
                ],
              ),
            ),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              '${items.length} produções disponíveis 100% grátis',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          ResponsiveMediaGrid(
            children: items.map((item) {
              return AngelCard(
                item: item,
                isTvMode: widget.settings.tvMode,
                onPlay: () => _openAngelItem(item),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
