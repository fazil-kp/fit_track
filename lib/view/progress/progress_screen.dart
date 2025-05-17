import 'package:fit_track/config/colors.dart';
import 'package:fit_track/vm/meal_log_vm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

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
    // Get last 7 days of data
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 6));
    final weeklyLogs = mealLogs.where((log) => log.date.isAfter(weekAgo)).toList();

    // Aggregate daily totals
    final Map<DateTime, Map<String, double>> dailyTotals = {};
    for (final log in weeklyLogs) {
      final date = DateTime(log.date.year, log.date.month, log.date.day);
      dailyTotals.putIfAbsent(date, () => {'calories': 0.0, 'protein': 0.0});
      dailyTotals[date]!['calories'] = dailyTotals[date]!['calories']! +
          log.foods.fold(
            0.0,
            (sum, food) => sum + (food.calories ?? 0.0),
          );
      dailyTotals[date]!['protein'] = dailyTotals[date]!['protein']! +
          log.foods.fold(
            0.0,
            (sum, food) => sum + (food.protein ?? 0.0),
          );
    }

    // Prepare data for charts
    final dates = List<DateTime>.generate(
      7,
      (index) => now.subtract(Duration(days: 6 - index)),
    );

    // Define goal values (could be user-configurable)
    const calorieGoal = 2000.0;
    const proteinGoal = 100.0;

    return Scaffold(
      body: CustomScrollView(
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
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (totalCalories > totalProtein ? totalCalories : totalProtein) * 1.2,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String label = group.x == 0 ? 'Calories' : 'Protein';
                              String value = group.x == 0 ? '${totalCalories.toStringAsFixed(0)} kcal' : '${totalProtein.toStringAsFixed(0)} g';
                              return BarTooltipItem(
                                '$label\n$value',
                                TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const style = TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text('Calories', style: style);
                                  case 1:
                                    return const Text('Protein', style: style);
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: totalCalories,
                                color: Colors.orange,
                                width: 40,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: totalProtein,
                                color: Colors.blue,
                                width: 40,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildWeeklyProgressCard(context, dailyTotals, dates, calorieGoal),
          ),
          SliverToBoxAdapter(
            child: _buildProteinChartCard(context, dailyTotals, dates, proteinGoal),
          ),
          SliverToBoxAdapter(
            child: _buildNutritionSummaryCard(
              context,
              dailyTotals,
              dates,
              calorieGoal,
              proteinGoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressCard(
    BuildContext context,
    Map<DateTime, Map<String, double>> dailyTotals,
    List<DateTime> dates,
    double calorieGoal,
  ) {
    return Container(
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
            'Weekly Nutrition Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: _CaloriesBarChart(
              dailyTotals: dailyTotals,
              dates: dates,
              goal: calorieGoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProteinChartCard(
    BuildContext context,
    Map<DateTime, Map<String, double>> dailyTotals,
    List<DateTime> dates,
    double proteinGoal,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Protein Intake',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: _ProteinLineChart(
              dailyTotals: dailyTotals,
              dates: dates,
              goal: proteinGoal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummaryCard(
    BuildContext context,
    Map<DateTime, Map<String, double>> dailyTotals,
    List<DateTime> dates,
    double calorieGoal,
    double proteinGoal,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _NutritionSummary(
            dailyTotals: dailyTotals,
            dates: dates,
            calorieGoal: calorieGoal,
            proteinGoal: proteinGoal,
          ),
        ],
      ),
    );
  }
}

// -- Chart and Summary widgets follow, unchanged, just formatted --

class _CaloriesBarChart extends StatelessWidget {
  final Map<DateTime, Map<String, double>> dailyTotals;
  final List<DateTime> dates;
  final double goal;

  const _CaloriesBarChart({
    required this.dailyTotals,
    required this.dates,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: goal * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(0)} kcal',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = dates[value.toInt()];
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return value % 500 == 0
                    ? Text(
                        '${value.toInt()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 500,
        ),
        borderData: FlBorderData(show: false),
        barGroups: dates.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value;
          final calories = dailyTotals[date]?['calories'] ?? 0.0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: calories,
                color: primary,
                width: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: goal,
              color: Colors.orange,
              strokeWidth: 2,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                labelResolver: (_) => 'Goal: ${goal.toInt()} kcal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProteinLineChart extends StatelessWidget {
  final Map<DateTime, Map<String, double>> dailyTotals;
  final List<DateTime> dates;
  final double goal;

  const _ProteinLineChart({
    required this.dailyTotals,
    required this.dates,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toStringAsFixed(1)} g',
                const TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          horizontalInterval: 25,
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final date = dates[value.toInt()];
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    DateFormat('E').format(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return value % 25 == 0
                    ? Text(
                        '${value.toInt()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: goal * 1.5,
        lineBarsData: [
          LineChartBarData(
            spots: dates.asMap().entries.map((entry) {
              final index = entry.key.toDouble();
              final protein = dailyTotals[entry.value]?['protein'] ?? 0.0;
              return FlSpot(index, protein);
            }).toList(),
            isCurved: true,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
          ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: goal,
              color: Colors.blue,
              strokeWidth: 2,
              dashArray: [5, 5],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                labelResolver: (_) => 'Goal: ${goal.toInt()} g',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionSummary extends StatelessWidget {
  final Map<DateTime, Map<String, double>> dailyTotals;
  final List<DateTime> dates;
  final double calorieGoal;
  final double proteinGoal;

  const _NutritionSummary({
    required this.dailyTotals,
    required this.dates,
    required this.calorieGoal,
    required this.proteinGoal,
  });

  @override
  Widget build(BuildContext context) {
    double totalCalories = 0;
    double totalProtein = 0;
    int daysAboveCalorieGoal = 0;
    int daysAboveProteinGoal = 0;

    for (final date in dates) {
      final calories = dailyTotals[date]?['calories'] ?? 0;
      final protein = dailyTotals[date]?['protein'] ?? 0;
      totalCalories += calories;
      totalProtein += protein;
      if (calories >= calorieGoal) daysAboveCalorieGoal++;
      if (protein >= proteinGoal) daysAboveProteinGoal++;
    }

    final avgCalories = totalCalories / dates.length;
    final avgProtein = totalProtein / dates.length;

    return Column(
      children: [
        _SummaryCard(
          title: 'Average Calories',
          value: '${avgCalories.toStringAsFixed(0)} kcal',
          icon: Icons.local_fire_department,
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          title: 'Average Protein',
          value: '${avgProtein.toStringAsFixed(1)} g',
          icon: Icons.fitness_center,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          title: 'Days Meeting Calorie Goal',
          value: '$daysAboveCalorieGoal/7 days',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _SummaryCard(
          title: 'Days Meeting Protein Goal',
          value: '$daysAboveProteinGoal/7 days',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
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
          Icon(icon, color: color, size: 28),
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
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
