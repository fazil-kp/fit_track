// ignore_for_file: deprecated_member_use

import 'package:fit_track/config/colors.dart';
import 'package:fit_track/vm/progress_vm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int currentIndex = 0;

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
          currentIndex = _tabController.index;
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

    return Column(
      children: [
        // Custom App Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nutrition Progress',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$dayName • $dateFormatted',
                    style: const TextStyle(
                      color: AppColors.textMedium,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Daily Nutrition Summary
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
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

        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            dividerColor: whiteColor,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMedium,
            tabs: const [
              Tab(icon: Icon(Icons.insights), text: 'Overview'),
              Tab(icon: Icon(Icons.calendar_today), text: 'Weekly'),
              Tab(icon: Icon(Icons.fitness_center), text: 'Macros'),
              Tab(icon: Icon(Icons.restaurant_menu), text: 'Meals'),
            ],
          ),
        ),

        // Page Content
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
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
          style: const TextStyle(
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
                  height: 200,
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
                              const TextStyle(
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
                                color: AppColors.textDark,
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
                                  color: AppColors.textDark,
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
                            color: Colors.grey.withOpacity(0.2),
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
                                color: Colors.grey.withOpacity(0.1),
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
                                color: Colors.grey.withOpacity(0.1),
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
                                color: Colors.grey.withOpacity(0.1),
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
                                color: Colors.grey.withOpacity(0.1),
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
                                const TextStyle(
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
                            color: Colors.grey.withOpacity(0.2),
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
                                    color: AppColors.textDark,
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
                                  color: AppColors.textDark,
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
                          color: AppColors.primary,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                              radius: 6,
                              color: AppColors.primary,
                              strokeWidth: 2,
                              strokeColor: AppColors.textLight,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withOpacity(0.2),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.4),
                                AppColors.primary.withOpacity(0.0),
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
          color: AppColors.primary,
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
                color: AppColors.fat,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildInfoCard(
                title: 'Lowest Day',
                value: weeklyCalories.isEmpty || weeklyCalories.every((e) => e == 0) ? '0' : weeklyCalories.where((e) => e > 0).reduce((a, b) => a < b ? a : b).toStringAsFixed(0),
                description: 'calories',
                icon: Icons.arrow_downward,
                color: AppColors.protein,
              ),
            ),
          ],
        ),
      ],
    );
  }

// Macros Page Content - continuing from where the code was cut off
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
              ? _buildEmptyPlaceholder('No macronutrient data for today')
              : Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: [
                            PieChartSectionData(
                              value: totalProtein,
                              title: '$proteinPercentage%',
                              color: AppColors.protein,
                              radius: 80,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            PieChartSectionData(
                              value: totalCarbs,
                              title: '$carbsPercentage%',
                              color: AppColors.carbs,
                              radius: 80,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            PieChartSectionData(
                              value: totalFat,
                              title: '$fatPercentage%',
                              color: AppColors.fat,
                              radius: 80,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacroLegendItem('Protein', AppColors.protein, proteinPercentage),
                        _buildMacroLegendItem('Carbs', AppColors.carbs, carbsPercentage),
                        _buildMacroLegendItem('Fat', AppColors.fat, fatPercentage),
                      ],
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                title: 'Protein Goal',
                value: '${(totalProtein / 150 * 100).toStringAsFixed(0)}%',
                description: '${totalProtein.toStringAsFixed(0)}g of 150g',
                icon: Icons.fitness_center,
                color: AppColors.protein,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildInfoCard(
                title: 'Carbs Goal',
                value: '${(totalCarbs / 250 * 100).toStringAsFixed(0)}%',
                description: '${totalCarbs.toStringAsFixed(0)}g of 250g',
                icon: Icons.grain,
                color: AppColors.carbs,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildInfoCard(
          title: 'Fat Goal',
          value: '${(totalFat / 65 * 100).toStringAsFixed(0)}%',
          description: '${totalFat.toStringAsFixed(0)}g of 65g',
          icon: Icons.opacity,
          color: AppColors.fat,
          isLarge: true,
        ),
      ],
    );
  }

  // Macro legend item
  Widget _buildMacroLegendItem(String title, Color color, String percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$title: $percentage%',
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Meals Page Content
  Widget _buildMealsPage(Map<String, double> mealCalories, Map<String, Map<String, double>> mealMacros) {
    final totalCalories = mealCalories.values.fold(0.0, (sum, item) => sum + item);
    final mealCategories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
    final mealColors = [AppColors.breakfast, AppColors.lunch, AppColors.dinner, AppColors.snacks];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildChartCard(
          title: 'Meal Distribution',
          icon: Icons.restaurant_menu,
          child: totalCalories == 0
              ? _buildEmptyPlaceholder('No meal data for today')
              : Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: mealCategories.map((category) {
                            final calories = mealCalories[category] ?? 0.0;
                            final percentage = totalCalories > 0 ? (calories / totalCalories * 100) : 0.0;
                            return PieChartSectionData(
                              value: calories,
                              title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
                              color: mealColors[mealCategories.indexOf(category)],
                              radius: 80,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: List.generate(mealCategories.length, (index) {
                        final category = mealCategories[index];
                        final calories = mealCalories[category] ?? 0.0;
                        final percentage = totalCalories > 0 ? (calories / totalCalories * 100) : 0.0;
                        return _buildMealLegendItem(
                          category,
                          mealColors[index],
                          percentage.toStringAsFixed(0),
                          calories.toStringAsFixed(0),
                        );
                      }),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 15),
        ...mealCategories.map((category) => _buildMealDetailCard(
              category,
              mealColors[mealCategories.indexOf(category)],
              mealCalories[category] ?? 0.0,
              mealMacros[category] ?? {'protein': 0.0, 'fat': 0.0, 'carbs': 0.0},
            )),
      ],
    );
  }

  // Meal legend item
  Widget _buildMealLegendItem(String title, Color color, String percentage, String calories) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$title: $percentage% ($calories kcal)',
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Meal detail card
  Widget _buildMealDetailCard(String title, Color color, double calories, Map<String, double> macros) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
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
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${calories.toStringAsFixed(0)} kcal',
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroItem('Protein', macros['protein'] ?? 0.0, AppColors.protein),
              _buildMacroItem('Carbs', macros['carbs'] ?? 0.0, AppColors.carbs),
              _buildMacroItem('Fat', macros['fat'] ?? 0.0, AppColors.fat),
            ],
          ),
        ],
      ),
    );
  }

  // Macro item
  Widget _buildMacroItem(String title, double value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textMedium,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toStringAsFixed(0)}g',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Chart card container
  Widget _buildChartCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
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
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  // Information card
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
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMedium,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: isLarge ? 32 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Empty placeholder
  Widget _buildEmptyPlaceholder(String message) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.textMedium,
            size: 48,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
