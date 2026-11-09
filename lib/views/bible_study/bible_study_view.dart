import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../services/app_localizations.dart';
import '../../services/youtube_service.dart';
import '../../widgets/explore_intro.dart';
import '../../widgets/responsive_media_grid.dart';
import '../../widgets/tv_focusable.dart';
import '../../widgets/video_card.dart';
import '../chapter/chapter_view.dart';
import '../player/player_view.dart';
import '../player/podcast_player_view.dart';

class BibleStudyView extends StatefulWidget {
  const BibleStudyView({
    super.key,
    required this.controller,
    required this.settings,
    required this.topicController,
    required this.topicFocusNode,
    required this.onSearch,
    this.onNavigateToAngel,
  });

  final HomeController controller;
  final SettingsController settings;
  final TextEditingController topicController;
  final FocusNode topicFocusNode;
  final VoidCallback onSearch;
  final VoidCallback? onNavigateToAngel;

  @override
  State<BibleStudyView> createState() => _BibleStudyViewState();
}

class _BibleStudyViewState extends State<BibleStudyView> {
  HomeController get _controller => widget.controller;
  SettingsController get _settings => widget.settings;

  Future<void> _openVideoLink() async {
    final form = GlobalKey<FormState>();
    var input = '';
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reproduzir por link'),
        content: Form(
          key: form,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'https://www.youtube.com/watch?v=...',
              labelText: 'Link do YouTube',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Informe o link';
              final id = YouTubeService.extractVideoId(v.trim());
              if (id == null) return 'Link inválido do YouTube';
              return null;
            },
            onSaved: (v) => input = v ?? '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState?.validate() ?? false) {
                form.currentState?.save();
                Navigator.of(ctx).pop();
                final id = YouTubeService.extractVideoId(input.trim())!;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PlayerView(
                      video: VideoItem(
                        id: id,
                        title: 'Vídeo por link',
                        channel: 'YouTube',
                        thumbnail: 'https://i.ytimg.com/vi/$id/hqdefault.jpg',
                      ),
                    ),
                  ),
                );
              }
            },
            child: const Text('Reproduzir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(_settings.language);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final selected = _controller.selectedTopic;

    return LayoutBuilder(
      builder: (context, constraints) {
        final margin = constraints.maxWidth < 600 ? 16.0 : 28.0;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1360),
            child: ListView(
              padding: EdgeInsets.fromLTRB(margin, 16, margin, 32),
              children: [
                ExploreIntro(
                  topic: selected?.title,
                  description: selected?.description,
                  controller: widget.topicController,
                  focusNode: widget.topicFocusNode,
                  onSearch: widget.onSearch,
                  onOpenLink: _openVideoLink,
                  onDraw: _controller.drawTopic,
                  strings: strings,
                  onExplore: selected != null && !_controller.confirmed
                      ? _controller.confirmTopic
                      : null,
                ),
                if (!_controller.confirmed && widget.onNavigateToAngel != null) ...[
                  const SizedBox(height: 24),
                  _angelDiscoveryBanner(strings, colors, theme),
                ],
                if (_controller.confirmed && selected != null) ...[
                  const SizedBox(height: 30),
                  Text(
                    strings.exploreThemeTitle,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selected.title,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    _tabChip(strings.tabVideos, Icons.ondemand_video_outlined, 0),
                    _tabChip(strings.tabSongs, Icons.music_note_outlined, 1),
                    _tabChip(strings.tabBible, Icons.menu_book_outlined, 2),
                    _tabChip(strings.tabPodcasts, Icons.mic_none_rounded, 3),
                  ]),
                  const SizedBox(height: 16),
                  switch (_controller.currentTab) {
                    2 => _bibleContent(strings),
                    3 => _podcastContent(),
                    _ => _videoContent(
                        _controller.currentTab == 0
                            ? _controller.videosFuture
                            : _controller.songsFuture,
                      ),
                  },
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _angelDiscoveryBanner(
      AppStrings strings, ColorScheme colors, ThemeData theme) {
    return TvFocusable(
      onPressed: widget.onNavigateToAngel ?? () {},
      borderRadius: BorderRadius.circular(24),
      focusedScale: _settings.tvMode ? 1.05 : 1.02,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F3B32),
              Color(0xFF08261F),
            ],
          ),
          border: Border.all(
            color: const Color(0xFFF4CA83).withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4CA83),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ANGEL.COM/PT-BR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E301F),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_open_rounded, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        strings.angelFreeBadge,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Cinema & Séries Angel Studios',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Assista a The Chosen (Os Escolhidos), O Jovem Davi, épicos bíblicos e produções familiares de fé sem cadastro ou login.',
              style: TextStyle(color: Color(0xFFDBEEE6), fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF4CA83),
                foregroundColor: const Color(0xFF1E301F),
              ),
              onPressed: widget.onNavigateToAngel,
              icon: const Icon(Icons.movie_filter_rounded),
              label: const Text('Explorar Catálogo Grátis da Angel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabChip(String title, IconData icon, int index) => TvFocusable(
        onPressed: () => _controller.setTab(index),
        borderRadius: BorderRadius.circular(20),
        focusedScale: _settings.tvMode ? 1.08 : 1.04,
        child: ChoiceChip(
          label: Text(title,
              style: TextStyle(fontSize: _settings.tvMode ? 15 : 13)),
          avatar: Icon(icon, size: _settings.tvMode ? 20 : 18),
          selected: _controller.currentTab == index,
          onSelected: (_) => _controller.setTab(index),
        ),
      );

  Widget _bibleContent(AppStrings strings) {
    final t = _controller.selectedTopic!;
    final references = _controller.getReferences();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_stories_rounded, size: 28, color: colors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(strings.relatedPassages,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${references.length} ${strings.chaptersSelectedForReading}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              if (t.detectedKeywords.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: t.detectedKeywords.map((kw) {
                    return Chip(
                      label: Text(kw, style: const TextStyle(fontSize: 12)),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: colors.secondaryContainer.withValues(alpha: 0.5),
                    );
                  }).toList(),
                ),
              ],
              if (t.verse.isNotEmpty && t.verse != t.reference) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(left: BorderSide(color: colors.primary, width: 3)),
                  ),
                  child: Text(
                    t.verse,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      if (references.isEmpty)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Text(strings.noPassagesFound),
          ),
        ),
      ...references.map((ref) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.onPrimaryContainer,
                child: const Icon(Icons.menu_book_outlined, size: 20),
              ),
              title: Text(ref, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(strings.readWholeChapter),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChapterView(
                  reference: ref,
                  preferredTranslation: _settings.bibleTranslation,
                ),
              )),
            ),
          )),
    ]);
  }

  Widget _videoContent(Future<List<VideoItem>>? future) {
    if (future == null) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<List<VideoItem>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const Icon(Icons.info_outline, size: 36),
                const SizedBox(height: 10),
                Text('${snapshot.error}', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _openYoutubeSearch(),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Pesquisar diretamente no YouTube'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    if (_controller.currentTab == 0) {
                      _controller.retryVideos();
                    } else {
                      _controller.retrySongs();
                    }
                  },
                  child: const Text('Tentar novamente'),
                ),
              ]),
            ),
          );
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const Text(
                  'A pesquisa não retornou vídeos. Tente abrir os resultados no YouTube.',
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _openYoutubeSearch(),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Pesquisar no YouTube'),
                ),
              ]),
            ),
          );
        }
        return ResponsiveMediaGrid(children: [
          for (final video in items)
            VideoCard(
              video: video,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PlayerView(video: video)),
              ),
            ),
        ]);
      },
    );
  }

  Future<void> _openYoutubeSearch() async {
    final topic = _controller.selectedTopic;
    final query = _controller.currentTab == 0
        ? (topic?.effectiveVideoQuery ?? 'estudo bíblico')
        : (topic?.effectiveSongQuery ?? 'louvor');

    final uri = Uri.https('www.youtube.com', '/results', {'search_query': query});
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir a pesquisa.')),
      );
    }
  }

  Widget _podcastContent() => FutureBuilder<List<PodcastItem>>(
        future: _controller.podcastsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  const Icon(Icons.info_outline, size: 36),
                  const SizedBox(height: 10),
                  Text('Erro: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _controller.retryPodcasts,
                    child: const Text('Tentar novamente'),
                  ),
                ]),
              ),
            );
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Nenhum episódio de podcast encontrado para este tema.'),
              ),
            );
          }
          return ResponsiveMediaGrid(
            children: items
                .map((item) => Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        leading: item.artwork.isEmpty
                            ? const Icon(Icons.podcasts, size: 40)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.artwork,
                                  width: 56,
                                  height: 56,
                                  cacheWidth: (56 * MediaQuery.devicePixelRatioOf(context)).ceil(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.podcasts),
                                ),
                              ),
                        title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text(item.show, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: const Icon(Icons.play_circle_outline),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PodcastPlayerView(podcast: item),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      );
}
