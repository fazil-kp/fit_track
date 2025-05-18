import 'package:fit_track/helper/extensions.dart';
import 'package:fit_track/model/meal_log_model.dart';
import 'package:fit_track/vm/meal_log_vm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Providers for chart data
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

// Define theme colors
class AppColors {
  static const Color primaryDark = Color(0xFF2C3E50);
  static const Color primaryLight = Color(0xFF34495E);
  static const Color accent = Color(0xFF3498DB);
  static const Color accentLight = Color(0xFF5DADE2);
  static const Color textLight = Color(0xFFF5F5F5);
  static const Color textDark = Color(0xFF333333);

  // Chart colors
  static const Color calories = Color(0xFFE74C3C);
  static const Color protein = Color(0xFF3498DB);
  static const Color fat = Color(0xFF2ECC71);
  static const Color carbs = Color(0xFF9B59B6);

  // Meal category colors
  static const Color breakfast = Color(0xFFFF9800);
  static const Color lunch = Color(0xFF3498DB);
  static const Color dinner = Color(0xFF2ECC71);
  static const Color snacks = Color(0xFF9B59B6);
}

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final todayNutrition = ref.watch(todayNutritionProvider);
    final weeklyCalories = ref.watch(weeklyCaloriesProvider);
    final mealCategoryCalories = ref.watch(mealCategoryCaloriesProvider);
    final mealCategoryMacros = ref.watch(mealCategoryMacrosProvider);

    // Extract the macro totals
    final totalProtein = todayNutrition['protein'] ?? 0.0;
    final totalCarbs = todayNutrition['carbs'] ?? 0.0;
    final totalFat = todayNutrition['fat'] ?? 0.0;
    final totalCalories = todayNutrition['calories'] ?? 0.0;

    // Day of week for header display
    final today = DateTime.now();
    final dayName = DateFormat('EEEE').format(today);
    final dateFormatted = DateFormat('MMMM d, y').format(today);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nutrition Progress',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$dayName • $dateFormatted',
                        style: TextStyle(
                          color: AppColors.textLight.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.accent,
                    radius: 22,
                    child: Icon(
                      Icons.person,
                      color: AppColors.textLight,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Daily Nutrition Summary
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent,
                    AppColors.accentLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Summary',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.insights,
                        color: AppColors.textLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutrientSummary(
                        'Calories',
                        totalCalories.toStringAsFixed(0),
                        'kcal',
                        AppColors.calories,
                      ),
                      _buildNutrientSummary(
                        'Protein',
                        totalProtein.toStringAsFixed(0),
                        'g',
                        AppColors.protein,
                      ),
                      _buildNutrientSummary(
                        'Carbs',
                        totalCarbs.toStringAsFixed(0),
                        'g',
                        AppColors.carbs,
                      ),
                      _buildNutrientSummary(
                        'Fat',
                        totalFat.toStringAsFixed(0),
                        'g',
                        AppColors.fat,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Custom Tab Bar
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.accent,
                ),
                labelColor: AppColors.textLight,
                unselectedLabelColor: AppColors.textLight.withOpacity(0.6),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Weekly'),
                  Tab(text: 'Macros'),
                  Tab(text: 'Meals'),
                ],
              ),
            ),

            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _tabController.animateTo(index);
                  });
                },
                children: [
                  // Overview Page
                  _buildOverviewPage(todayNutrition),

                  // Weekly Page
                  _buildWeeklyPage(weeklyCalories),

                  // Macros Page
                  _buildMacrosPage(totalProtein, totalCarbs, totalFat),

                  // Meals Page
                  _buildMealsPage(mealCategoryCalories, mealCategoryMacros),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nutrient summary widget
  Widget _buildNutrientSummary(String title, String value, String unit, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.textLight,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: AppColors.textLight.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // Overview Page Content
  Widget _buildOverviewPage(Map<String, double> todayNutrition) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildChartCard(
          title: 'Today\'s Nutrition',
          icon: Icons.bar_chart,
          child: todayNutrition.values.every((v) => v == 0)
              ? _buildEmptyPlaceholder('No nutrition data for today')
              : SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: [todayNutrition['calories']!, todayNutrition['protein']!, todayNutrition['fat']!, todayNutrition['carbs']!].reduce((a, b) => a > b ? a : b) * 1.2,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final labels = ['Calories', 'Protein', 'Fat', 'Carbs'];
                            final units = ['kcal', 'g', 'g', 'g'];
                            final value = rod.toY.toStringAsFixed(0);
                            return BarTooltipItem(
                              '${labels[group.x]}\n$value ${units[group.x]}',
                              TextStyle(
                                color: AppColors.textLight,
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
                                color: AppColors.textLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              );
                              switch (value.toInt()) {
                                case 0:
                                  return const Text('Calories', style: style);
                                case 1:
                                  return const Text('Protein', style: style);
                                case 2:
                                  return const Text('Fat', style: style);
                                case 3:
                                  return const Text('Carbs', style: style);
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
                                  color: AppColors.textLight,
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
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 100,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppColors.textLight.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: todayNutrition['calories']!,
                              color: AppColors.calories,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 2000, // Target calories
                                color: AppColors.textLight.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: todayNutrition['protein']!,
                              color: AppColors.protein,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 150, // Target protein
                                color: AppColors.textLight.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: todayNutrition['fat']!,
                              color: AppColors.fat,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 65, // Target fat
                                color: AppColors.textLight.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 3,
                          barRods: [
                            BarChartRodData(
                              toY: todayNutrition['carbs']!,
                              color: AppColors.carbs,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 250, // Target carbs
                                color: AppColors.textLight.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                title: 'Daily Goal',
                value: '${(todayNutrition['calories']! / 2000 * 100).toStringAsFixed(0)}%',
                description: 'of 2000 kcal',
                icon: Icons.flag,
                color: AppColors.calories,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildInfoCard(
                title: 'Protein Goal',
                value: '${(todayNutrition['protein']! / 150 * 100).toStringAsFixed(0)}%',
                description: 'of 150g',
                icon: Icons.fitness_center,
                color: AppColors.protein,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Weekly Page Content
  Widget _buildWeeklyPage(List<double> weeklyCalories) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildChartCard(
          title: 'Weekly Calorie Trend',
          icon: Icons.timeline,
          child: weeklyCalories.every((v) => v == 0)
              ? _buildEmptyPlaceholder('No calorie data this week')
              : SizedBox(
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final day = DateFormat('EEE').format(
                                DateTime.now().subtract(
                                  Duration(days: 6 - spot.x.toInt()),
                                ),
                              );
                              return LineTooltipItem(
                                '$day\n${spot.y.toStringAsFixed(0)} kcal',
                                TextStyle(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 500,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppColors.textLight.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final day = DateFormat('EEE').format(
                                DateTime.now().subtract(
                                  Duration(days: 6 - value.toInt()),
                                ),
                              );
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: weeklyCalories.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                          isCurved: true,
                          color: AppColors.calories,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                              radius: 6,
                              color: AppColors.calories,
                              strokeWidth: 2,
                              strokeColor: AppColors.textLight,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.calories.withOpacity(0.2),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.calories.withOpacity(0.4),
                                AppColors.calories.withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      minY: 0,
                      maxY: weeklyCalories.isEmpty ? 2000 : weeklyCalories.reduce((a, b) => a > b ? a : b) * 1.2,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 15),
        _buildInfoCard(
          title: 'Weekly Average',
          value: weeklyCalories.isEmpty ? '0' : (weeklyCalories.reduce((a, b) => a + b) / weeklyCalories.length).toStringAsFixed(0),
          description: 'calories per day',
          icon: Icons.calendar_today,
          color: AppColors.calories,
          isLarge: true,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                title: 'Highest Day',
                value: weeklyCalories.isEmpty ? '0' : weeklyCalories.reduce((a, b) => a > b ? a : b).toStringAsFixed(0),
                description: 'calories',
                icon: Icons.arrow_upward,
                color: AppColors.calories,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildInfoCard(
                title: 'Lowest Day',
                value: weeklyCalories.isEmpty || weeklyCalories.every((e) => e == 0) ? '0' : weeklyCalories.where((e) => e > 0).reduce((a, b) => a < b ? a : b).toStringAsFixed(0),
                description: 'calories',
                icon: Icons.arrow_downward,
                color: AppColors.calories,
              ),
            ),
          ],
        ),
      ],
    );
  }

// Macros Page Content
  Widget _buildMacrosPage(double totalProtein, double totalCarbs, double totalFat) {
    final totalMacros = totalProtein + totalCarbs + totalFat;
    final proteinPercentage = totalMacros > 0 ? (totalProtein / totalMacros * 100).toStringAsFixed(1) : '0';
    final carbsPercentage = totalMacros > 0 ? (totalCarbs / totalMacros * 100).toStringAsFixed(1) : '0';
    final fatPercentage = totalMacros > 0 ? (totalFat / totalMacros * 100).toStringAsFixed(1) : '0';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildChartCard(
          title: 'Macronutrient Distribution',
          icon: Icons.pie_chart,
          child: totalMacros == 0
              ? _buildEmptyPlaceholder('No macronutrient data')
              : SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                        enabled: true,
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: [
                        PieChartSectionData(
                          color: AppColors.protein,
                          value: totalProtein,
                          title: '$proteinPercentage%',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        PieChartSectionData(
                          color: AppColors.carbs,
                          value: totalCarbs,
                          title: '$carbsPercentage%',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        PieChartSectionData(
                          color: AppColors.fat,
                          value: totalFat,
                          title: '$fatPercentage%',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 20),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Protein', AppColors.protein),
            const SizedBox(width: 20),
            _buildLegendItem('Carbs', AppColors.carbs),
            const SizedBox(width: 20),
            _buildLegendItem('Fat', AppColors.fat),
          ],
        ),
        const SizedBox(height: 20),
        // Macro details
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                title: 'Protein',
                value: '${totalProtein.toStringAsFixed(0)}g',
                description: '$proteinPercentage% of total',
                icon: Icons.fitness_center,
                color: AppColors.protein,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildInfoCard(
                title: 'Carbs',
                value: '${totalCarbs.toStringAsFixed(0)}g',
                description: '$carbsPercentage% of total',
                icon: Icons.grain,
                color: AppColors.carbs,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildInfoCard(
          title: 'Fat',
          value: '${totalFat.toStringAsFixed(0)}g',
          description: '$fatPercentage% of total',
          icon: Icons.opacity,
          color: AppColors.fat,
          isLarge: true,
        ),
      ],
    );
  }

// Legend item for pie chart
  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

// Meals Page Content
  Widget _buildMealsPage(Map<String, double> mealCategoryCalories, Map<String, Map<String, double>> mealCategoryMacros) {
    final hasMealData = mealCategoryCalories.values.any((value) => value > 0);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildChartCard(
          title: 'Calories by Meal',
          icon: Icons.restaurant,
          child: !hasMealData
              ? _buildEmptyPlaceholder('No meal data recorded')
              : SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: mealCategoryCalories.values.isEmpty ? 1000 : mealCategoryCalories.values.reduce((a, b) => a > b ? a : b) * 1.2,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
                            final value = rod.toY.toStringAsFixed(0);
                            return BarTooltipItem(
                              '${categories[group.x]}\n$value kcal',
                              TextStyle(
                                color: AppColors.textLight,
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
                                color: AppColors.textLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              );
                              switch (value.toInt()) {
                                case 0:
                                  return const Text('Breakfast', style: style);
                                case 1:
                                  return const Text('Lunch', style: style);
                                case 2:
                                  return const Text('Dinner', style: style);
                                case 3:
                                  return const Text('Snacks', style: style);
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
                                  color: AppColors.textLight,
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
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 100,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppColors.textLight.withOpacity(0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: mealCategoryCalories['Breakfast'] ?? 0,
                              color: AppColors.breakfast,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: mealCategoryCalories['Lunch'] ?? 0,
                              color: AppColors.lunch,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: mealCategoryCalories['Dinner'] ?? 0,
                              color: AppColors.dinner,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 3,
                          barRods: [
                            BarChartRodData(
                              toY: mealCategoryCalories['Snacks'] ?? 0,
                              color: AppColors.snacks,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 15),
        _buildMealDetails('Breakfast', mealCategoryCalories['Breakfast'] ?? 0, mealCategoryMacros['Breakfast']!, AppColors.breakfast),
        const SizedBox(height: 15),
        _buildMealDetails('Lunch', mealCategoryCalories['Lunch'] ?? 0, mealCategoryMacros['Lunch']!, AppColors.lunch),
        const SizedBox(height: 15),
        _buildMealDetails('Dinner', mealCategoryCalories['Dinner'] ?? 0, mealCategoryMacros['Dinner']!, AppColors.dinner),
        const SizedBox(height: 15),
        _buildMealDetails('Snacks', mealCategoryCalories['Snacks'] ?? 0, mealCategoryMacros['Snacks']!, AppColors.snacks),
      ],
    );
  }

// Meal details card
  Widget _buildMealDetails(String mealName, double calories, Map<String, double> macros, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    mealName,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${calories.toStringAsFixed(0)} kcal',
                style: TextStyle(
                  color: AppColors.textLight.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroDetail('Protein', '${macros['protein']?.toStringAsFixed(0) ?? "0"}g', AppColors.protein),
              _buildMacroDetail('Carbs', '${macros['carbs']?.toStringAsFixed(0) ?? "0"}g', AppColors.carbs),
              _buildMacroDetail('Fat', '${macros['fat']?.toStringAsFixed(0) ?? "0"}g', AppColors.fat),
            ],
          ),
        ],
      ),
    );
  }

// Macro detail for meal card
  Widget _buildMacroDetail(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textLight.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

// Chart card widget
  Widget _buildChartCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                icon,
                color: AppColors.textLight.withOpacity(0.8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

// Info card widget
  Widget _buildInfoCard({
    required String title,
    required String value,
    required String description,
    required IconData icon,
    required Color color,
    bool isLarge = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textLight.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: isLarge ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        description,
                        style: TextStyle(
                          color: AppColors.textLight.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Empty placeholder for charts
  Widget _buildEmptyPlaceholder(String message) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              color: AppColors.textLight.withOpacity(0.3),
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: AppColors.textLight.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
