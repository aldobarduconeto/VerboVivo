import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import '../models/media_model.dart';

class PodcastController extends ChangeNotifier {
  PodcastController(this.podcast) {
    _init();
  }

  final PodcastItem podcast;
  final AudioPlayer player = AudioPlayer();
  static bool _linuxAudioInitialized = false;

  StreamSubscription<PlaybackEvent>? _events;
  bool _loading = true;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  bool get isPlaying => player.playing;

  void _init() {
    _events = player.playbackEventStream.listen(
      (_) => notifyListeners(),
      onError: (Object e, StackTrace s) {
        _showError('Erro durante a reprodução do podcast.');
      },
    );
    load();
  }

  void _showError(String message) {
    _loading = false;
    _error = message;
    notifyListeners();
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    if (defaultTargetPlatform == TargetPlatform.linux && !_linuxAudioInitialized) {
      try {
        JustAudioMediaKit.ensureInitialized(linux: true, windows: false);
        _linuxAudioInitialized = true;
      } catch (_) {
        _showError('O player de áudio requer libmpv no Linux.');
        return;
      }
    }

    try {
      await player.setUrl(podcast.audioUrl).timeout(const Duration(seconds: 30));
      _loading = false;
      notifyListeners();
    } catch (_) {
      _showError('Não foi possível carregar o episódio. Verifique sua conexão.');
    }
  }

  Future<void> togglePlayback() async {
    try {
      if (player.processingState == ProcessingState.completed) {
        await player.pause();
        await player.seek(Duration.zero);
        await player.play();
      } else if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }
      notifyListeners();
    } catch (_) {
      _showError('Falha ao alternar reprodução.');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await player.seek(position);
    } catch (_) {
      _showError('Falha ao navegar no áudio.');
    }
  }

  @override
  void dispose() {
    unawaited(_events?.cancel());
    unawaited(player.dispose());
    super.dispose();
  }
}
