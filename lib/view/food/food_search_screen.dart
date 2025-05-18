// ignore_for_file: deprecated_member_use

import 'package:fit_track/config/colors.dart';
import 'package:fit_track/config/theme.dart';
import 'package:fit_track/model/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fit_track/vm/food_vm.dart';
import 'package:flutter/services.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _selectedFoods = <Food>{};
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _searchFoods() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      ref.read(foodProvider.notifier).searchFoods(query);
      HapticFeedback.mediumImpact();
    } else {
      // Custom snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.onErrorContainer),
              const SizedBox(width: 12),
              Text(
                'Please enter a food name to search',
                style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _addToFoodLog() {
    if (_selectedFoods.isNotEmpty) {
      ref.read(foodProvider.notifier).addToLog(_selectedFoods.toList());
      // Provide haptic feedback
      HapticFeedback.mediumImpact();
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: primary),
              const SizedBox(width: 12),
              Text(
                '${_selectedFoods.length} items added to food log',
                style: TextStyle(color: primary),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      // Clear selections
      setState(() {
        _selectedFoods.clear();
      });
    }
  }

  Widget _buildNutritionDetail(String label, double? value, String unit, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            value != null ? '${value.toStringAsFixed(1)} $unit' : 'N/A',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: value != null ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = ref.watch(foodProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.5),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Header
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.2),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          Text(
                            'Find Your Food',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Search for food items to track your nutrition',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Search bar
                FadeTransition(
                  opacity: _animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(_animation),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(16),
                        color: colorScheme.surface,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 45,
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: 'Search for salad, apple, etc..',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
                                      prefixIcon: Icon(Icons.restaurant_menu, color: colorScheme.primary),
                                    ),
                                    style: TextStyle(color: colorScheme.onSurface),
                                    onSubmitted: (_) => _searchFoods(),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: colorScheme.primary,
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.search, color: Colors.white),
                                  onPressed: _searchFoods,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Selected foods counter and add button
                if (_selectedFoods.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.shopping_cart, size: 18, color: colorScheme.onSecondaryContainer),
                              const SizedBox(width: 8),
                              Text(
                                '${_selectedFoods.length} ${_selectedFoods.length == 1 ? 'item' : 'items'} selected',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _addToFoodLog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                          label: Text('Add to Log', style: context.bodySmall?.copyWith(color: Colors.white, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                // Results
                Expanded(
                  child: foods.when(
                    data: (foodList) => foodList.isEmpty
                        ? FadeTransition(
                            opacity: _animation,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 80,
                                    color: colorScheme.primary.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No foods found',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try searching for something else',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            itemCount: foodList.length,
                            itemBuilder: (context, index) {
                              final food = foodList[index];
                              final isSelected = _selectedFoods.contains(food);

                              return AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  final delay = index * 0.1;
                                  final startTime = delay;
                                  final endTime = startTime + 0.6;
                                  final animationValue = (_animation.value - startTime) / (endTime - startTime);
                                  final currentAnimValue = animationValue.clamp(0.0, 1.0);

                                  return FadeTransition(
                                    opacity: AlwaysStoppedAnimation(currentAnimValue),
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.3),
                                        end: Offset.zero,
                                      ).animate(AlwaysStoppedAnimation(currentAnimValue)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    onTap: () {
                                      _showFoodDetailsDialog(context, food, colorScheme);
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colorScheme.shadow.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(16),
                                        color: isSelected ? colorScheme.primaryContainer.withOpacity(0.7) : colorScheme.surface,
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Row(
                                            children: [
                                              // Food icon container
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: colorScheme.primary.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    _getFoodIcon(food.label ?? ""),
                                                    color: colorScheme.primary,
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              // Food info
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      food.label ?? "Unknown Food",
                                                      style: theme.textTheme.titleMedium?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        _buildNutrientChip(
                                                          'cal',
                                                          food.calories?.toStringAsFixed(0) ?? 'N/A',
                                                          Colors.orangeAccent,
                                                          colorScheme,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        _buildNutrientChip(
                                                          'prot',
                                                          food.protein != null ? '${food.protein?.toStringAsFixed(1)}g' : 'N/A',
                                                          Colors.purple,
                                                          colorScheme,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        _buildNutrientChip(
                                                          'carbs',
                                                          food.carbs != null ? '${food.carbs?.toStringAsFixed(1)}g' : 'N/A',
                                                          Colors.blueAccent,
                                                          colorScheme,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Selection checkbox
                                              Theme(
                                                data: ThemeData(
                                                  checkboxTheme: CheckboxThemeData(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                  ),
                                                ),
                                                child: Transform.scale(
                                                  scale: 1.1,
                                                  child: Checkbox(
                                                    value: isSelected,
                                                    activeColor: colorScheme.primary,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if (value == true) {
                                                          _selectedFoods.add(food);
                                                        } else {
                                                          _selectedFoods.remove(food);
                                                        }
                                                      });
                                                      // Provide haptic feedback
                                                      HapticFeedback.selectionClick();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    loading: () => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Searching for foods...',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: colorScheme.onErrorContainer,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              e.toString().contains('Unauthorized') ? 'Invalid API Key' : 'Error Loading Data',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colorScheme.onErrorContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              e.toString().contains('Unauthorized') ? 'Please verify your CalorieNinjas API key in settings.' : 'Unable to fetch food data. Please try again later.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onErrorContainer,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Retry or go to settings
                                if (e.toString().contains('Unauthorized')) {
                                  // Navigate to settings
                                  // You would need to add navigation to settings here
                                } else {
                                  // Retry the search
                                  _searchFoods();
                                }
                              },
                              icon: Icon(
                                e.toString().contains('Unauthorized') ? Icons.settings : Icons.refresh,
                                color: colorScheme.primary,
                              ),
                              label: Text(
                                e.toString().contains('Unauthorized') ? 'Go to Settings' : 'Try Again',
                                style: TextStyle(color: colorScheme.primary),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.surface,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientChip(String label, String value, Color color, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFoodIcon(String foodName) {
    final lowerCaseName = foodName.toLowerCase();

    if (lowerCaseName.contains('apple') || lowerCaseName.contains('banana') || lowerCaseName.contains('orange') || lowerCaseName.contains('fruit')) {
      return Icons.apple;
    } else if (lowerCaseName.contains('chicken') || lowerCaseName.contains('beef') || lowerCaseName.contains('meat') || lowerCaseName.contains('fish') || lowerCaseName.contains('steak')) {
      return Icons.restaurant;
    } else if (lowerCaseName.contains('salad') || lowerCaseName.contains('vegetable') || lowerCaseName.contains('broccoli') || lowerCaseName.contains('carrot')) {
      return Icons.eco;
    } else if (lowerCaseName.contains('burger') || lowerCaseName.contains('pizza') || lowerCaseName.contains('fries') || lowerCaseName.contains('fast food')) {
      return Icons.fastfood;
    } else if (lowerCaseName.contains('cake') || lowerCaseName.contains('cookie') || lowerCaseName.contains('ice cream') || lowerCaseName.contains('sweet') || lowerCaseName.contains('dessert')) {
      return Icons.cake;
    } else if (lowerCaseName.contains('coffee') || lowerCaseName.contains('tea') || lowerCaseName.contains('juice') || lowerCaseName.contains('water') || lowerCaseName.contains('drink') || lowerCaseName.contains('soda')) {
      return Icons.local_cafe;
    } else if (lowerCaseName.contains('bread') || lowerCaseName.contains('toast') || lowerCaseName.contains('sandwich') || lowerCaseName.contains('bagel')) {
      return Icons.breakfast_dining;
    } else if (lowerCaseName.contains('egg') || lowerCaseName.contains('breakfast')) {
      return Icons.egg;
    }

    return Icons.restaurant_menu;
  }

  void _showFoodDetailsDialog(BuildContext context, Food food, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(bottom: 16),
            ),
            // Food icon and name
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(
                      _getFoodIcon(food.label ?? ""),
                      color: colorScheme.primary,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.label ?? "Unknown Food",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (food.servingSize != null)
                        Text(
                          'Serving: ${food.servingSize?.toStringAsFixed(1)}g',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                // Add to log button if not already selected
                if (!_selectedFoods.contains(food))
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedFoods.add(food);
                      });
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: Text('Add', style: context.bodySmall?.copyWith(color: Colors.white, fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                else
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedFoods.remove(food);
                      });
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    color: colorScheme.error,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            // Main nutrition info in a row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMainNutrientInfo(
                    'Calories',
                    food.calories?.toStringAsFixed(0) ?? "N/A",
                    'kcal',
                    Icons.local_fire_department,
                    Colors.redAccent,
                    colorScheme,
                  ),
                  _buildDivider(),
                  _buildMainNutrientInfo(
                    'Protein',
                    food.protein?.toStringAsFixed(1) ?? "N/A",
                    'g',
                    Icons.fitness_center,
                    Colors.purpleAccent,
                    colorScheme,
                  ),
                  _buildDivider(),
                  _buildMainNutrientInfo(
                    'Carbs',
                    food.carbs?.toStringAsFixed(1) ?? "N/A",
                    'g',
                    Icons.grain,
                    Colors.amberAccent,
                    colorScheme,
                  ),
                  _buildDivider(),
                  _buildMainNutrientInfo(
                    'Fat',
                    food.fat?.toStringAsFixed(1) ?? "N/A",
                    'g',
                    Icons.opacity,
                    Colors.blueAccent,
                    colorScheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Detailed nutrition info
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        'Detailed Nutrition Information',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      color: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildNutritionDetail(
                              'Sugar',
                              food.sugar,
                              'g',
                              Icons.bubble_chart,
                              Colors.pinkAccent,
                            ),
                            const Divider(height: 24),
                            _buildNutritionDetail(
                              'Fiber',
                              food.fiber,
                              'g',
                              Icons.alt_route,
                              Colors.greenAccent,
                            ),
                            const Divider(height: 24),
                            _buildNutritionDetail(
                              'Saturated Fat',
                              food.saturatedFat,
                              'g',
                              Icons.opacity_outlined,
                              Colors.orangeAccent,
                            ),
                            const Divider(height: 24),
                            _buildNutritionDetail(
                              'Sodium',
                              food.sodium,
                              'mg',
                              Icons.water_drop_outlined,
                              Colors.blueGrey,
                            ),
                            const Divider(height: 24),
                            _buildNutritionDetail(
                              'Potassium',
                              food.potassium,
                              'mg',
                              Icons.bolt,
                              Colors.amber,
                            ),
                            const Divider(height: 24),
                            _buildNutritionDetail(
                              'Cholesterol',
                              food.cholesterol,
                              'mg',
                              Icons.circle_outlined,
                              Colors.redAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Close button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.outline),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5));
  }

  Widget _buildMainNutrientInfo(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              '· $label',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
