import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reading_plan_model.dart';
import '../services/reading_plan_service.dart';

class ReadingPlanController extends ChangeNotifier {
  ReadingPlanController._();
  static final instance = ReadingPlanController._();

  static const _activePlanKey = 'reading_plan_active_id';
  static const _progressPrefix = 'reading_plan_progress_';
  static const _streakKey = 'reading_plan_streak_days';
  static const _lastDateKey = 'reading_plan_last_day_epoch';

  String? _activePlanId = 'plan-sabedoria-30';
  final Map<String, Set<int>> _completedDays = {}; // planId -> set of dayNumbers
  int _streak = 0;
  bool _isLoaded = false;

  String get activePlanId => _activePlanId ?? 'plan-sabedoria-30';
  ReadingPlan get activePlan =>
      ReadingPlanService.getPlanById(activePlanId) ?? ReadingPlanService.plans.first;
  List<ReadingPlan> get allPlans => ReadingPlanService.plans;
  int get streak => _streak;
  bool get isLoaded => _isLoaded;

  Set<int> getCompletedDays(String planId) {
    return _completedDays[planId] ?? const <int>{};
  }

  bool isDayCompleted(String planId, int dayNumber) {
    return _completedDays[planId]?.contains(dayNumber) ?? false;
  }

  double getProgress(String planId) {
    final plan = ReadingPlanService.getPlanById(planId);
    if (plan == null || plan.durationDays == 0) return 0.0;
    final completed = getCompletedDays(planId).length;
    return (completed / plan.durationDays).clamp(0.0, 1.0);
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _activePlanId = prefs.getString(_activePlanKey) ?? 'plan-sabedoria-30';
      _streak = prefs.getInt(_streakKey) ?? 0;

      for (final plan in ReadingPlanService.plans) {
        final raw = prefs.getStringList('$_progressPrefix${plan.id}');
        if (raw != null) {
          _completedDays[plan.id] = raw.map((e) => int.tryParse(e) ?? 0).where((d) => d > 0).toSet();
        }
      }

      _isLoaded = true;
      notifyListeners();
    } catch (_) {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> setActivePlan(String planId) async {
    if (_activePlanId == planId) return;
    _activePlanId = planId;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_activePlanKey, planId);
    } catch (_) {}
  }

  Future<void> toggleDayCompleted(String planId, int dayNumber) async {
    final currentSet = _completedDays[planId] ?? <int>{};
    final updated = Set<int>.from(currentSet);

    final wasCompleted = updated.contains(dayNumber);
    if (wasCompleted) {
      updated.remove(dayNumber);
    } else {
      updated.add(dayNumber);
      _updateStreak();
    }

    _completedDays[planId] = updated;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        '$_progressPrefix$planId',
        updated.map((e) => e.toString()).toList(),
      );
    } catch (_) {}
  }

  void _updateStreak() {
    final now = DateTime.now();
    _streak = (_streak + 1);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(_streakKey, _streak);
      prefs.setInt(_lastDateKey, now.millisecondsSinceEpoch);
    }).catchError((_) {});
  }

  Future<void> resetPlan(String planId) async {
    _completedDays[planId] = <int>{};
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_progressPrefix$planId');
    } catch (_) {}
  }
}
