import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../models/media_model.dart';
import '../../services/youtube_stream_service.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({super.key, required this.video, this.resolveStream});

  final VideoItem video;
  final Future<ResolvedVideo> Function(String)? resolveStream;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  Player? _player;
  VideoController? _controller;
  StreamSubscription<dynamic>? _errors;
  bool _loading = true;
  String? _error;
  int _loadAttempt = 0;
  final FocusNode _playerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final attempt = ++_loadAttempt;
    final previousPlayer = _player;
    final previousErrors = _errors;
    _player = null;
    _errors = null;
    _controller = null;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await previousErrors?.cancel();
      await previousPlayer?.dispose();
      if (!mounted) return;

      final String rawId = widget.video.id;
      final bool isDirectUri =
          rawId.startsWith('http://') || rawId.startsWith('https://');

      ResolvedVideo source;
      if (isDirectUri) {
        source = ResolvedVideo(Uri.parse(rawId));
      } else {
        final cached = YouTubeStreamService.getCached(rawId);
        if (cached != null) {
          source = cached;
        } else {
          final resolve =
              widget.resolveStream ?? const YouTubeStreamService().resolve;
          try {
            source = await resolve(rawId);
          } catch (_) {
            // Contingência de resolução: força a URL de streaming direto interno
            source = ResolvedVideo(Uri.parse('https://www.youtube.com/watch?v=$rawId'));
          }
        }
      }

      if (!mounted) return;
      MediaKit.ensureInitialized();
      if (!mounted || attempt != _loadAttempt) return;

      final player = _player = Player(
        configuration: const PlayerConfiguration(
          bufferSize: 32 * 1024 * 1024,
          logLevel: MPVLogLevel.error,
        ),
      );
      final controller = _controller = VideoController(
        player,
        configuration: const VideoControllerConfiguration(
          enableHardwareAcceleration: true,
        ),
      );

      _errors = player.stream.error.listen((err) {
        if (mounted && attempt == _loadAttempt) {
          _tryFallbackDirectStream(player, rawId);
        }
      });

      // Abre e força a reprodução exclusivamente no player interno
      await player.open(
        Media(source.video.toString()),
        play: true,
      );

      if (!mounted || attempt != _loadAttempt || _error != null) return;
      setState(() => _loading = false);

      // Se houver trilha de áudio separada, anexa ao player interno
      final audio = source.audio;
      if (audio != null) {
        unawaited(
          player.setAudioTrack(AudioTrack.uri(audio.toString())).catchError((_) {}),
        );
      }

      _playerFocusNode.requestFocus();
    } catch (_) {
      if (attempt == _loadAttempt) {
        final player = _player;
        if (player != null) {
          _tryFallbackDirectStream(player, widget.video.id);
        } else {
          _showError();
        }
      }
    }
  }

  void _tryFallbackDirectStream(Player player, String rawId) {
    if (!mounted) return;
    try {
      final fallbackUri = 'https://www.youtube.com/watch?v=$rawId';
      player.open(Media(fallbackUri), play: true).then((_) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = null;
          });
        }
      }).catchError((_) {
        _showError();
      });
    } catch (_) {
      _showError();
    }
  }

  void _showError() {
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = 'Não foi possível carregar este vídeo no player interno.';
    });
  }

  KeyEventResult _handleRemoteKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;
    final player = _player;

    if (player != null) {
      // D-pad Esquerda / Retroceder 10s
      if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.mediaRewind) {
        final pos = player.state.position - const Duration(seconds: 10);
        player.seek(pos < Duration.zero ? Duration.zero : pos);
        return KeyEventResult.handled;
      }

      // D-pad Direita / Avançar 10s
      if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.mediaFastForward) {
        final pos = player.state.position + const Duration(seconds: 10);
        player.seek(pos);
        return KeyEventResult.handled;
      }

      // D-pad Centro / Enter / Espaço / Botão A / PlayPause
      if (key == LogicalKeyboardKey.select ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.gameButtonA ||
          key == LogicalKeyboardKey.mediaPlayPause ||
          key == LogicalKeyboardKey.mediaPlay ||
          key == LogicalKeyboardKey.mediaPause) {
        player.playOrPause();
        return KeyEventResult.handled;
      }
    }

    // Botão Voltar (Escape / Backspace / Botão B do Gamepad)
    if (key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.gameButtonB ||
        key == LogicalKeyboardKey.browserBack ||
        key == LogicalKeyboardKey.goBack) {
      Navigator.of(context).maybePop();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    unawaited(_errors?.cancel());
    unawaited(_player?.dispose());
    _playerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.video.title, maxLines: 1)),
        body: Focus(
          focusNode: _playerFocusNode,
          autofocus: true,
          onKeyEvent: _handleRemoteKey,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(child: _video()),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.video.channel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tv_rounded,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            'Controle: ◀ -10s | ▶ +10s | OK Play/Pause | B Voltar',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _video() {
    final error = _error;
    if (error != null) {
      final theme = Theme.of(context);
      final colors = theme.colorScheme;

      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Miniatura do Vídeo com Overlay interno
                  if (widget.video.thumbnail.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            widget.video.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF0F2B24),
                              child: const Center(
                                child: Icon(Icons.movie_filter_rounded,
                                    size: 48, color: Color(0xFFF4CA83)),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 14,
                            right: 14,
                            child: Text(
                              widget.video.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.play_circle_outline_rounded,
                              color: Color(0xFFF4CA83),
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Reprodução Interna no Aplicativo',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ocorreu uma instabilidade na transmissão deste vídeo. Pressione abaixo para forçar uma nova tentativa de reprodução com servidor alternativo.',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF4CA83),
                            foregroundColor: const Color(0xFF1E301F),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: _load,
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          label: const Text(
                            'Forçar Reprodução no Aplicativo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded, size: 16),
                          label: const Text('Voltar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final controller = _controller;
    if (_loading || controller == null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          if (widget.video.thumbnail.isNotEmpty)
            Image.network(
              widget.video.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          Container(
            color: Colors.black.withValues(alpha: 0.72),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 42,
                    height: 42,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFF4CA83)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Carregando ${widget.video.title}...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Video(controller: controller);
  }
}

// Backwards compatibility alias
typedef PlayerScreen = PlayerView;
