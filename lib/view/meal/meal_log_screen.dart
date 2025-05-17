import 'package:fit_track/config/colors.dart';
import 'package:fit_track/config/theme.dart';
import 'package:fit_track/route/route.dart';
import 'package:fit_track/route/route_list.dart';
import 'package:fit_track/view/insight_placeholder.dart';
import 'package:fit_track/vm/meal_log_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MealLogScreen extends ConsumerWidget {
  const MealLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealLogs = ref.watch(mealLogProvider);
    final today = DateTime.now();
    final todayLogs = mealLogs.where((log) => log.date.year == today.year && log.date.month == today.month && log.date.day == today.day).toList();

    // Sort logs by time
    todayLogs.sort((a, b) => a.date.compareTo(b.date));

    // Calculate totals
    double totalCalories = todayLogs.fold(0.0, (sum, log) => sum + log.foods.fold(0.0, (foodSum, food) => foodSum + (food.calories ?? 0.0)));

    double totalProtein = todayLogs.fold(0.0, (sum, log) => sum + log.foods.fold(0.0, (foodSum, food) => foodSum + (food.protein ?? 0.0)));

    // Define meal times for categorization
    final Map<String, List<dynamic>> mealCategories = {
      'Breakfast': [],
      'Lunch': [],
      'Dinner': [],
      'Snacks': [],
    };

    // Categorize meals
    for (var log in todayLogs) {
      final hour = log.date.hour;
      if (hour >= 5 && hour < 11) {
        mealCategories['Breakfast']!.add(log);
      } else if (hour >= 11 && hour < 16) {
        mealCategories['Lunch']!.add(log);
      } else if (hour >= 16 && hour < 22) {
        mealCategories['Dinner']!.add(log);
      } else {
        mealCategories['Snacks']!.add(log);
      }
    }

    return FitTrackPlaceHolder(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => routeX.pushNamed(searchMain),
        backgroundColor: primary,
        icon: const Icon(Icons.add_circle, color: Colors.white),
        label: Text("Add Meal", style: context.bodySmall?.copyWith(fontSize: 14, color: Colors.white)),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primary.withOpacity(0.8),
                    primary.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Nutrition',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _NutritionCard(
                          title: 'Calories',
                          value: '${totalCalories.toStringAsFixed(0)}',
                          unit: 'kcal',
                          icon: Icons.local_fire_department,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _NutritionCard(
                          title: 'Protein',
                          value: '${totalProtein.toStringAsFixed(0)}',
                          unit: 'g',
                          icon: Icons.fitness_center,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Date Display
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                DateFormat('EEEE, MMMM d').format(today),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),

          // Meals for the day
          SliverToBoxAdapter(
            child: todayLogs.isEmpty
                ? _EmptyMealDisplay()
                : Column(
                    children: [
                      for (String category in mealCategories.keys)
                        if (mealCategories[category]!.isNotEmpty)
                          _MealCategorySection(
                            category: category,
                            logs: mealCategories[category]!,
                            ref: ref,
                          ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _NutritionCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealCategorySection extends StatelessWidget {
  final String category;
  final List<dynamic> logs;
  final WidgetRef ref;

  const _MealCategorySection({
    required this.category,
    required this.logs,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    double categoryCalories = logs.fold(0.0, (sum, log) => sum + log.foods.fold(0.0, (foodSum, food) => foodSum + (food.calories ?? 0.0)));

    IconData categoryIcon;
    switch (category) {
      case 'Breakfast':
        categoryIcon = Icons.wb_sunny;
        break;
      case 'Lunch':
        categoryIcon = Icons.restaurant;
        break;
      case 'Dinner':
        categoryIcon = Icons.nightlight;
        break;
      default:
        categoryIcon = Icons.cookie;
    }

    return Container(
      margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                categoryIcon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${categoryCalories.toStringAsFixed(0)} kcal',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey.withOpacity(0.1),
                ),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return _MealCard(log: log, ref: ref);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final dynamic log;
  final WidgetRef ref;

  const _MealCard({required this.log, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: primary.withOpacity(0.1),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(5, 0, 16, 16),
        title: Text(
          DateFormat('h:mm a').format(log.date),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${log.foods.length} ${log.foods.length == 1 ? 'item' : 'items'} · ${log.foods.fold(0.0, (sum, food) => sum + (food.calories ?? 0.0)).toStringAsFixed(0)} kcal',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: const Icon(Icons.keyboard_arrow_down),
        children: log.foods.map<Widget>((food) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.label ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _NutrientBadge(
                            label: 'Calories',
                            value: '${food.calories?.toStringAsFixed(0) ?? '0'} kcal',
                            color: Colors.orange.shade100,
                            textColor: Colors.orange.shade800,
                          ),
                          const SizedBox(width: 8),
                          _NutrientBadge(
                            label: 'Protein',
                            value: '${food.protein?.toStringAsFixed(1) ?? '0'} g',
                            color: Colors.blue.shade100,
                            textColor: Colors.blue.shade800,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.grey,
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Remove Food'),
                          content: Text('Are you sure you want to remove ${food.label ?? 'this food'} from your log?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(mealLogProvider.notifier).removeFood(log, food);
                                Navigator.of(context).pop();
                              },
                              child: const Text('REMOVE'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NutrientBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  const _NutrientBadge({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

class _EmptyMealDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/empty_meal.png', // Add this image to your assets
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.restaurant,
                size: 80,
                color: primary.withOpacity(0.5),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'No meals logged today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first meal to start tracking your nutrition',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => routeX.pushNamed(searchMain),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add Your First Meal'),
          ),
        ],
      ),
    );
  }
}
