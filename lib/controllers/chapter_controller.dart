import 'package:flutter/foundation.dart';
import '../services/bible_service.dart';

class ChapterController extends ChangeNotifier {
  ChapterController({
    required String initialReference,
    String? initialTranslation,
    double initialFontSize = 18.0,
    BibleService? bibleService,
  })  : _currentReference = initialReference,
        _currentTranslation = initialTranslation ?? 'ACF11',
        _fontSize = initialFontSize,
        _bibleService = bibleService ?? BibleService() {
    load();
  }

  final BibleService _bibleService;
  String _currentReference;
  String _currentTranslation;
  double _fontSize;
  Future<BibleChapter>? _chapterFuture;

  String get currentReference => _currentReference;
  String get currentTranslation => _currentTranslation;
  double get fontSize => _fontSize;
  Future<BibleChapter>? get chapterFuture => _chapterFuture;

  String? get previousChapter => BibleService.previousChapter(_currentReference);
  String? get nextChapter => BibleService.nextChapter(_currentReference);

  void load() {
    final future = _bibleService.chapter(
      _currentReference,
      preferredTranslation: _currentTranslation,
    );
    _chapterFuture = future;
    notifyListeners();

    // Pré-carrega de forma antecipada e assíncrona o próximo e o capítulo anterior
    future.then((_) {
      final next = nextChapter;
      if (next != null) {
        _bibleService.prefetchChapter(next, preferredTranslation: _currentTranslation);
      }
      final prev = previousChapter;
      if (prev != null) {
        _bibleService.prefetchChapter(prev, preferredTranslation: _currentTranslation);
      }
    }).catchError((_) {});
  }

  void goTo(String reference) {
    if (_currentReference == reference) return;
    _currentReference = reference;
    load();
  }

  void setTranslation(String translation) {
    if (_currentTranslation == translation) return;
    _currentTranslation = translation;
    load();
  }

  void increaseFontSize() {
    _fontSize = (_fontSize + 2).clamp(14.0, 32.0);
    notifyListeners();
  }

  void decreaseFontSize() {
    _fontSize = (_fontSize - 2).clamp(14.0, 32.0);
    notifyListeners();
  }
}
