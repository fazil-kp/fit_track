import 'package:fit_track/helper/extensions.dart';
import 'package:fit_track/model/meal_log_model.dart';
import 'package:fit_track/vm/meal_log_vm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todayMealLogsProvider = Provider<List<MealLog>>((ref) {
  final mealLogs = ref.watch(mealLogProvider);
  final today = DateTime.now();
  return mealLogs.where((log) => log.date.isSameDay(today)).toList()..sort((a, b) => a.date.compareTo(b.date));
});

final todayNutritionProvider = Provider<Map<String, double>>((ref) {
  final todayLogs = ref.watch(todayMealLogsProvider);
  return {
    'calories': todayLogs.fold(0.0, (sum, log) => sum + log.foods.fold(0.0, (s, f) => s + (f.calories ?? 0.0))),
    'protein': todayLogs.fold(0.0, (sum, log) => sum + log.foods.fold(0.0, (s, f) => s + (f.protein ?? 0.0))),
    'fat': todayLogs.fold(0.0, (sum, log) => sum + log.foods.fold(0.0, (s, f) => s + (f.fat ?? 0.0))),
    'carbs': todayLogs.fold(0.0, (sum, log) => sum + log.foods.fold(0.0, (s, f) => s + (f.carbs ?? 0.0))),
  };
});

final weeklyCaloriesProvider = Provider<List<double>>((ref) {
  final logs = ref.watch(mealLogProvider);
  final today = DateTime.now();
  final weekStart = today.subtract(Duration(days: today.weekday - 1));
  return List.generate(7, (i) {
    final day = weekStart.add(Duration(days: i));
    return logs.where((log) => log.date.isSameDay(day)).fold(0.0, (sum, log) => sum + log.foods.fold(0.0, (s, f) => s + (f.calories ?? 0.0)));
  });
});

final mealCategoryCaloriesProvider = Provider<Map<String, double>>((ref) {
  final todayLogs = ref.watch(todayMealLogsProvider);
  final categories = {'Breakfast': 0.0, 'Lunch': 0.0, 'Dinner': 0.0, 'Snacks': 0.0};
  for (var log in todayLogs) {
    final hour = log.date.hour;
    final calories = log.foods.fold(0.0, (sum, food) => sum + (food.calories ?? 0.0));
    if (hour >= 5 && hour < 11) {
      categories['Breakfast'] = categories['Breakfast']! + calories;
    } else if (hour >= 11 && hour < 16) {
      categories['Lunch'] = categories['Lunch']! + calories;
    } else if (hour >= 16 && hour < 22) {
      categories['Dinner'] = categories['Dinner']! + calories;
    } else {
      categories['Snacks'] = categories['Snacks']! + calories;
    }
  }
  return categories;
});

final mealCategoryMacrosProvider = Provider<Map<String, Map<String, double>>>((ref) {
  final todayLogs = ref.watch(todayMealLogsProvider);
  final categories = {
    'Breakfast': {'protein': 0.0, 'fat': 0.0, 'carbs': 0.0},
    'Lunch': {'protein': 0.0, 'fat': 0.0, 'carbs': 0.0},
    'Dinner': {'protein': 0.0, 'fat': 0.0, 'carbs': 0.0},
    'Snacks': {'protein': 0.0, 'fat': 0.0, 'carbs': 0.0},
  };
  for (var log in todayLogs) {
    final hour = log.date.hour;
    final category = (hour >= 5 && hour < 11)
        ? 'Breakfast'
        : (hour >= 11 && hour < 16)
            ? 'Lunch'
            : (hour >= 16 && hour < 22)
                ? 'Dinner'
                : 'Snacks';
    for (var food in log.foods) {
      categories[category]!['protein'] = categories[category]!['protein']! + (food.protein ?? 0.0);
      categories[category]!['fat'] = categories[category]!['fat']! + (food.fat ?? 0.0);
      categories[category]!['carbs'] = categories[category]!['carbs']! + (food.carbs ?? 0.0);
    }
  }
  return categories;
});
