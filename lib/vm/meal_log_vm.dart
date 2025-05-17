import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:fit_track/model/food_model.dart';
import 'package:fit_track/model/meal_log_model.dart';

final mealLogProvider = StateNotifierProvider<MealLogViewModel, List<MealLog>>((ref) => MealLogViewModel());

class MealLogViewModel extends StateNotifier<List<MealLog>> {
  final Box<MealLog> _box = Hive.box<MealLog>('mealLogs');

  MealLogViewModel() : super([]) {
    _loadLogs();
  }

  void _loadLogs() {
    state = _box.values.toList();
  }

  void addFoods(List<Food> foods) {
    final now = DateTime.now();
    final newLog = MealLog(date: now, foods: foods);
    _box.add(newLog);
    state = [...state, newLog];
  }

  void removeFood(MealLog log, Food food) {
    final updatedFoods = log.foods.where((f) => f != food).toList();
    final logIndex = state.indexWhere((l) => l.date == log.date);

    if (updatedFoods.isEmpty) {
      if (logIndex != -1) {
        _box.deleteAt(logIndex);
        state = [
          for (var i = 0; i < state.length; i++)
            if (i != logIndex) state[i]
        ];
      }
    } else {
      final updatedLog = MealLog(date: log.date, foods: updatedFoods);
      if (logIndex != -1) {
        _box.putAt(logIndex, updatedLog);
        state = [
          for (var i = 0; i < state.length; i++)
            if (i == logIndex) updatedLog else state[i]
        ];
      }
    }
  }
}
