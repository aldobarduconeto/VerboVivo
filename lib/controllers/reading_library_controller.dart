import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingLibraryController extends ChangeNotifier {
  ReadingLibraryController._();

  static final instance = ReadingLibraryController._();
  static const _lastReadKey = 'reading_last_chapter';
  static const _bookmarksKey = 'reading_bookmarks';

  String? _lastRead;
  List<String> _bookmarks = const [];
  Future<void> _pendingWrite = Future.value();

  String? get lastRead => _lastRead;
  List<String> get bookmarks => _bookmarks;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _lastRead = prefs.getString(_lastReadKey);
      _bookmarks = List.unmodifiable(prefs.getStringList(_bookmarksKey) ?? []);
      notifyListeners();
    } catch (error) {
      debugPrint('Could not load reading library: $error');
    }
  }

  Future<bool> recordReading(String reference) => _write((prefs) async {
        if (_lastRead == reference) return true;
        if (!await prefs.setString(_lastReadKey, reference)) return false;
        _lastRead = reference;
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
