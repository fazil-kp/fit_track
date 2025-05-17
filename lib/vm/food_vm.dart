import 'dart:async';

import 'package:fit_track/model/food_model.dart';
import 'package:fit_track/repository/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foodProvider = AsyncNotifierProvider<FoodNotifier, List<Food>>(FoodNotifier.new);

class FoodNotifier extends AsyncNotifier<List<Food>> {
  @override
  Future<List<Food>> build() async => [];

  Future<void> searchFoods(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    try {
      final foods = await ref.read(apiServiceProvider).searchFood(query);
      state = AsyncData(foods);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
