import 'package:fit_track/vm/food_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foods = ref.watch(foodProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter food name (e.g., apple or chicken sandwich)',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              ref.read(foodProvider.notifier).searchFoods(value);
            },
          ),
        ),
        Expanded(
          child: foods.when(
            data: (foodList) => foodList.isEmpty
                ? const Center(child: Text('No foods found. Try another search.'))
                : ListView.builder(
                    itemCount: foodList.length,
                    itemBuilder: (context, index) {
                      final food = foodList[index];
                      return ListTile(
                        title: Text(food.label),
                        subtitle: Text('Calories: ${food.calories.toStringAsFixed(1)} kcal'),
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  e.toString().contains('Unauthorized') ? 'Error: Invalid API key. Please contact support or verify your CalorieNinjas API key.' : 'Error: $e',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
