import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/devotional_model.dart';
import '../services/devotional_service.dart';

class DevotionalController extends ChangeNotifier {
  DevotionalController._({DevotionalService? service})
      : _service = service ?? const DevotionalService();

  static final instance = DevotionalController._();

  final DevotionalService _service;
  static const _streakKey = 'verbovivo_devotional_streak';
  static const _lastCompletedDateKey = 'verbovivo_devotional_last_date';
  static const _completedListKey = 'verbovivo_devotional_completed_list';

  int _streakCount = 0;
  String? _lastCompletedDate;
  Set<String> _completedDates = {};
  late DevotionalModel _todayDevotional;

  int get streakCount => _streakCount;
  bool get isCompletedToday =>
      _lastCompletedDate == _formatDate(DateTime.now());
  DevotionalModel get todayDevotional => _todayDevotional;
  Set<String> get completedDates => Set.unmodifiable(_completedDates);

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> load() async {
    _todayDevotional = _service.getDevotionalForDate(DateTime.now());
    try {
      final prefs = await SharedPreferences.getInstance();
      _streakCount = prefs.getInt(_streakKey) ?? 0;
      _lastCompletedDate = prefs.getString(_lastCompletedDateKey);
      final list = prefs.getStringList(_completedListKey) ?? [];
      _completedDates = list.toSet();

      // Check if streak was broken (missed more than 1 day)
      _validateStreak();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading devotional preferences: $e');
    }
  }

  void _validateStreak() {
    if (_lastCompletedDate == null) {
      _streakCount = 0;
      return;
    }
    final today = DateTime.now();
    final todayStr = _formatDate(today);
    final yesterdayStr = _formatDate(today.subtract(const Duration(days: 1)));

    // If last completed date is neither today nor yesterday, streak reset
    if (_lastCompletedDate != todayStr && _lastCompletedDate != yesterdayStr) {
      _streakCount = 0;
    }
  }

  Future<bool> markCompletedToday() async {
    final today = DateTime.now();
    final todayStr = _formatDate(today);

    if (_lastCompletedDate == todayStr) {
      return true; // Already completed today
    }

    final yesterdayStr = _formatDate(today.subtract(const Duration(days: 1)));
    if (_lastCompletedDate == yesterdayStr) {
      _streakCount += 1;
    } else {
      _streakCount = 1;
    }

    _lastCompletedDate = todayStr;
    _completedDates.add(todayStr);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_streakKey, _streakCount);
      await prefs.setString(_lastCompletedDateKey, todayStr);
      await prefs.setStringList(_completedListKey, _completedDates.toList());
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error saving devotional streak: $e');
      notifyListeners();
      return false;
    }
  }

  DevotionalModel getForDate(DateTime date) =>
      _service.getDevotionalForDate(date);
}
