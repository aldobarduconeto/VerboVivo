import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/podcast_controller.dart';
import '../../models/media_model.dart';

class PodcastPlayerView extends StatefulWidget {
  const PodcastPlayerView({
    super.key,
    required this.podcast,
    this.controller,
  });

  final PodcastItem podcast;
  final PodcastController? controller;

  @override
  State<PodcastPlayerView> createState() => _PodcastPlayerViewState();
}

class _PodcastPlayerViewState extends State<PodcastPlayerView> {
  late final PodcastController _controller;
  final _dragPosition = ValueNotifier<double?>(null);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PodcastController(widget.podcast);
  }

  @override
  void dispose() {
    _dragPosition.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _openEpisode() async {
    try {
      if (await launchUrl(Uri.parse(widget.podcast.audioUrl),
          mode: LaunchMode.externalApplication)) return;
    } catch (_) {}
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o episódio.')),
      );
    }
  }

  String _format(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final error = _controller.error;
        final loading = _controller.loading;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.podcast.show, maxLines: 1),
            actions: [
              IconButton(
                tooltip: 'Abrir no navegador',
                icon: const Icon(Icons.open_in_new),
                onPressed: _openEpisode,
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: widget.podcast.artwork.isEmpty
                              ? Container(
                                  color: colors.primaryContainer,
                                  child: Icon(Icons.podcasts,
                                      size: 80, color: colors.onPrimaryContainer),
                                )
                              : Image.network(
                                  widget.podcast.artwork,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: colors.primaryContainer,
                                    child: Icon(Icons.podcasts,
                                        size: 80, color: colors.onPrimaryContainer),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.podcast.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.podcast.show,
                    style: TextStyle(color: colors.onSurfaceVariant),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  if (error != null) ...[
                    Text(error, textAlign: TextAlign.center, style: TextStyle(color: colors.error)),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: _controller.load, child: const Text('Tentar novamente')),
                  ] else if (loading) ...[
                    const Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()),
                  ] else ...[
                    StreamBuilder<Duration>(
                      stream: _controller.player.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final duration = _controller.player.duration ?? widget.podcast.duration ?? Duration.zero;
                        final max = duration.inMilliseconds.toDouble();
                        final pos = position.inMilliseconds.toDouble().clamp(0.0, max);

                        return ValueListenableBuilder<double?>(
                          valueListenable: _dragPosition,
                          builder: (context, drag, _) {
                            final current = drag ?? pos;
                            return Column(
                              children: [
                                Slider(
                                  value: max > 0 ? current.clamp(0.0, max) : 0.0,
                                  max: max > 0 ? max : 1.0,
                                  onChanged: (val) => _dragPosition.value = val,
                                  onChangeEnd: (val) {
                                    _dragPosition.value = null;
                                    _controller.seek(Duration(milliseconds: val.round()));
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_format(Duration(milliseconds: current.round()))),
                                    Text(_format(duration)),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 36,
                          icon: const Icon(Icons.replay_10_rounded),
                          onPressed: () {
                            final pos = _controller.player.position - const Duration(seconds: 10);
                            _controller.seek(pos < Duration.zero ? Duration.zero : pos);
                          },
                        ),
                        const SizedBox(width: 16),
                        FloatingActionButton.large(
                          onPressed: _controller.togglePlayback,
                          child: Icon(
                            _controller.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 48,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          iconSize: 36,
                          icon: const Icon(Icons.forward_30_rounded),
                          onPressed: () {
                            final dur = _controller.player.duration ?? Duration.zero;
                            final pos = _controller.player.position + const Duration(seconds: 30);
                            _controller.seek(pos > dur ? dur : pos);
                          },
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Backwards compatibility alias
typedef PodcastPlayerScreen = PodcastPlayerView;
