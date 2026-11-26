import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import '../models/ambient_track_model.dart';

class AmbientAudioController extends ChangeNotifier {
  AmbientAudioController._() {
    _init();
  }

  static final instance = AmbientAudioController._();
  static bool _linuxAudioInitialized = false;

  final AudioPlayer _player = AudioPlayer();

  static const List<AmbientTrack> presets = [
    AmbientTrack(
      id: 'track-piano-paz',
      title: 'Piano Contemplativo',
      subtitle: 'Melodias suaves para meditação na Palavra',
      audioUrl: 'https://ia800301.us.archive.org/15/items/peaceful-piano-ambient/peaceful-piano.mp3',
      iconName: 'piano',
    ),
    AmbientTrack(
      id: 'track-harpa-davi',
      title: 'Harpa de Davi',
      subtitle: 'Acordes serenos inspirados nos Salmos',
      audioUrl: 'https://ia800902.us.archive.org/21/items/calm-harp-melody/calm-harp.mp3',
      iconName: 'harp',
    ),
    AmbientTrack(
      id: 'track-chuva-paz',
      title: 'Chuva Serena & Paz',
      subtitle: 'Som natural relaxante para foco e oração',
      audioUrl: 'https://ia800201.us.archive.org/12/items/soft-rain-ambient/soft-rain.mp3',
      iconName: 'rain',
    ),
    AmbientTrack(
      id: 'track-cordas-adoracao',
      title: 'Cordas de Adoração (Worship Pad)',
      subtitle: 'Atmosfera contínua e reverente',
      audioUrl: 'https://ia600301.us.archive.org/15/items/worship-pad-ambient/worship-pad.mp3',
      iconName: 'pad',
    ),
    AmbientTrack(
      id: 'track-brisa-suave',
      title: 'Brisa Suave da Manhã',
      subtitle: 'Frescor da aurora e comunhão silenciosa',
      audioUrl: 'https://ia800904.us.archive.org/30/items/gentle-breeze-nature/gentle-breeze.mp3',
      iconName: 'breeze',
    ),
  ];

  AmbientTrack? _currentTrack;
  bool _isPlaying = false;
  bool _isLoading = false;
  double _volume = 0.65;
  Duration? _sleepTimerDuration;
  Timer? _sleepTimer;
  DateTime? _timerEndTime;
  String? _error;

  AmbientTrack? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  double get volume => _volume;
  Duration? get sleepTimerDuration => _sleepTimerDuration;
  String? get error => _error;

  int? get remainingTimerMinutes {
    if (_timerEndTime == null) return null;
    final diff = _timerEndTime!.difference(DateTime.now()).inMinutes;
    return diff > 0 ? diff : 0;
  }

  void _init() {
    _player.playerStateStream.listen((state) {
      final playing = state.playing && state.processingState != ProcessingState.completed;
      if (_isPlaying != playing) {
        _isPlaying = playing;
        notifyListeners();
      }
    });

    _player.setLoopMode(LoopMode.one).catchError((_) {});
  }

  Future<void> _ensurePlatformAudio() async {
    if (defaultTargetPlatform == TargetPlatform.linux && !_linuxAudioInitialized) {
      try {
        JustAudioMediaKit.ensureInitialized(linux: true, windows: false);
        _linuxAudioInitialized = true;
      } catch (_) {}
    }
  }

  Future<void> playTrack(AmbientTrack track) async {
    _error = null;
    _currentTrack = track;
    _isLoading = true;
    notifyListeners();

    await _ensurePlatformAudio();

    try {
      await _player.stop();
      await _player.setVolume(_volume);
      await _player.setUrl(track.audioUrl).timeout(const Duration(seconds: 15));
      await _player.setLoopMode(LoopMode.one);
      await _player.play();
      _isLoading = false;
      _isPlaying = true;
      notifyListeners();
    } catch (_) {
      _isLoading = false;
      _isPlaying = false;
      _error = 'Áudio ambiente indisponível no momento.';
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (_currentTrack == null) {
      await playTrack(presets.first);
      return;
    }

    if (_isPlaying) {
      await _player.pause();
      _isPlaying = false;
    } else {
      await _player.play();
      _isPlaying = true;
    }
    notifyListeners();
  }

  Future<void> stop() async {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _timerEndTime = null;
    _sleepTimerDuration = null;

    try {
      await _player.stop();
    } catch (_) {}
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> setVolume(double val) async {
    final clamped = val.clamp(0.0, 1.0);
    _volume = clamped;
    notifyListeners();
    try {
      await _player.setVolume(clamped);
    } catch (_) {}
  }

  void setSleepTimer(Duration? duration) {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerDuration = duration;

    if (duration == null) {
      _timerEndTime = null;
      notifyListeners();
      return;
    }

    _timerEndTime = DateTime.now().add(duration);
    notifyListeners();

    _sleepTimer = Timer(duration, () {
      stop();
    });
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
