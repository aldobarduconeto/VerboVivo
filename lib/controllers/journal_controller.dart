import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_model.dart';

class JournalController extends ChangeNotifier {
  JournalController._();

  static final instance = JournalController._();

  static const _highlightsKey = 'verbovivo_verse_highlights';
  static const _prayersKey = 'verbovivo_prayer_items';

  Map<String, VerseHighlight> _highlights = {}; // key: "chapterRef:verseNum"
  List<PrayerItem> _prayers = [];

  List<VerseHighlight> get allHighlights =>
      List.unmodifiable(_highlights.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  List<PrayerItem> get allPrayers =>
      List.unmodifiable(_prayers..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  List<PrayerItem> get activePrayers =>
      List.unmodifiable(_prayers.where((p) => !p.isAnswered).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  List<PrayerItem> get answeredPrayers =>
      List.unmodifiable(_prayers.where((p) => p.isAnswered).toList()
        ..sort((a, b) => (b.answeredAt ?? b.createdAt).compareTo(a.answeredAt ?? a.createdAt)));

  String _verseKey(String chapterRef, int verseNum) => '$chapterRef:$verseNum';

  VerseHighlight? getHighlight(String chapterRef, int verseNum) {
    return _highlights[_verseKey(chapterRef, verseNum)];
  }

  Map<int, VerseHighlight> highlightsForChapter(String chapterRef) {
    final result = <int, VerseHighlight>{};
    for (final h in _highlights.values) {
      if (h.chapterReference.toLowerCase() == chapterRef.toLowerCase()) {
        result[h.verseNumber] = h;
      }
    }
    return result;
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load highlights
      final rawHighlights = prefs.getString(_highlightsKey);
      if (rawHighlights != null) {
        final decoded = jsonDecode(rawHighlights) as List<dynamic>;
        _highlights = {
          for (final item in decoded)
            _verseKey(item['chapterReference'] as String, item['verseNumber'] as int):
                VerseHighlight.fromJson(item as Map<String, dynamic>)
        };
      }

      // Load prayers
      final rawPrayers = prefs.getString(_prayersKey);
      if (rawPrayers != null) {
        final decoded = jsonDecode(rawPrayers) as List<dynamic>;
        _prayers = decoded
            .map((item) => PrayerItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading journal items: $e');
    }
  }

  Future<bool> setHighlight({
    required String chapterReference,
    required int verseNumber,
    required String reference,
    required String text,
    required String colorKey,
    String? note,
  }) async {
    final highlight = VerseHighlight(
      chapterReference: chapterReference,
      verseNumber: verseNumber,
      reference: reference,
      text: text,
      colorKey: colorKey,
      note: note,
      createdAt: DateTime.now(),
    );

    _highlights[_verseKey(chapterReference, verseNumber)] = highlight;
    notifyListeners();
    return _persistHighlights();
  }

  Future<bool> removeHighlight(String chapterReference, int verseNumber) async {
    final removed = _highlights.remove(_verseKey(chapterReference, verseNumber));
    if (removed != null) {
      notifyListeners();
      return _persistHighlights();
    }
    return true;
  }

  Future<bool> _persistHighlights() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _highlights.values.map((h) => h.toJson()).toList();
      await prefs.setString(_highlightsKey, jsonEncode(list));
      return true;
    } catch (e) {
      debugPrint('Error saving highlights: $e');
      return false;
    }
  }

  // --- Prayer Methods ---

  Future<bool> addPrayer({
    required String title,
    required String description,
    String? scriptureReference,
  }) async {
    final prayer = PrayerItem(
      id: 'prayer_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      description: description.trim(),
      scriptureReference: scriptureReference?.trim(),
      createdAt: DateTime.now(),
      isAnswered: false,
    );

    _prayers.insert(0, prayer);
    notifyListeners();
    return _persistPrayers();
  }

  Future<bool> togglePrayerAnswered(String id) async {
    final index = _prayers.indexWhere((p) => p.id == id);
    if (index == -1) return false;

    final current = _prayers[index];
    final willBeAnswered = !current.isAnswered;

    _prayers[index] = current.copyWith(
      isAnswered: willBeAnswered,
      answeredAt: willBeAnswered ? DateTime.now() : null,
    );

    notifyListeners();
    return _persistPrayers();
  }

  Future<bool> deletePrayer(String id) async {
    _prayers.removeWhere((p) => p.id == id);
    notifyListeners();
    return _persistPrayers();
  }

  Future<bool> _persistPrayers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _prayers.map((p) => p.toJson()).toList();
      await prefs.setString(_prayersKey, jsonEncode(list));
      return true;
    } catch (e) {
      debugPrint('Error saving prayers: $e');
      return false;
    }
  }
}
