import 'package:fit_track/repository/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_track/model/food_model.dart';
import 'package:fit_track/vm/meal_log_vm.dart';

final foodProvider = AsyncNotifierProvider<FoodViewModel, List<Food>>(FoodViewModel.new);

class FoodViewModel extends AsyncNotifier<List<Food>> {
  @override
  Future<List<Food>> build() async => [];

  Future<void> searchFoods(String query) async {
    state = const AsyncValue.loading();
    try {
      final foods = await ref.read(apiServiceProvider).searchFood(query);
      state = AsyncValue.data(foods);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void addToLog(List<Food> selectedFoods) {
    ref.read(mealLogProvider.notifier).addFoods(selectedFoods);
    state = const AsyncValue.data([]);
  }
}