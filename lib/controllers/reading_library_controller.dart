import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingLibraryController extends ChangeNotifier {
  ReadingLibraryController._();

  static final instance = ReadingLibraryController._();
  static const _lastReadKey = 'reading_last_chapter';
  static const _historyKey = 'reading_recent_chapters';
  static const _bookmarksKey = 'reading_bookmarks';
  static const _historyLimit = 30;

  List<String> _history = const [];
  List<String> _bookmarks = const [];
  Future<void> _pendingWrite = Future.value();

  String? get lastRead => _history.firstOrNull;
  List<String> get history => _history;
  List<String> get bookmarks => _bookmarks;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final previousChapter = prefs.getString(_lastReadKey);
      _history = List.unmodifiable(
        (prefs.getStringList(_historyKey) ??
                [if (previousChapter != null) previousChapter])
            .take(_historyLimit),
      );
      _bookmarks = List.unmodifiable(prefs.getStringList(_bookmarksKey) ?? []);
      notifyListeners();
    } catch (error) {
      debugPrint('Could not load reading library: $error');
    }
  }

  Future<bool> recordReading(String reference) => _write((prefs) async {
        if (lastRead == reference) return true;
        final updated = [
          reference,
          ..._history.where((chapter) => chapter != reference),
        ].take(_historyLimit).toList();
        if (!await prefs.setStringList(_historyKey, updated)) return false;
        _history = List.unmodifiable(updated);
        notifyListeners();
        return true;
      });

  Future<bool> toggleBookmark(String reference) => _write((prefs) async {
        final updated = [..._bookmarks];
        if (!updated.remove(reference)) updated.insert(0, reference);
        if (!await prefs.setStringList(_bookmarksKey, updated)) return false;
        _bookmarks = List.unmodifiable(updated);
        notifyListeners();
        return true;
      });

  Future<bool> _write(Future<bool> Function(SharedPreferences) update) {
    final result = _pendingWrite.then((_) async {
      try {
        return await update(await SharedPreferences.getInstance());
      } catch (error) {
        debugPrint('Could not save reading library: $error');
        return false;
      }
    });
    _pendingWrite = result.then<void>((_) {});
    return result;
  }
}
