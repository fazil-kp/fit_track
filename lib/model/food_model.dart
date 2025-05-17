
class Food {
  final String label;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double sugar;
  final double fiber;
  final double servingSize;
  final double sodium;
  final double potassium;
  final double saturatedFat;
  final double cholesterol;

  Food({
    required this.label,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.sugar,
    required this.fiber,
    required this.servingSize,
    required this.sodium,
    required this.potassium,
    required this.saturatedFat,
    required this.cholesterol,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      label: json['name'] ?? 'Unknown',
      calories: (json['calories'] ?? 0.0).toDouble(),
      protein: (json['protein_g'] ?? 0.0).toDouble(),
      fat: (json['fat_total_g'] ?? 0.0).toDouble(),
      carbs: (json['carbohydrates_total_g'] ?? 0.0).toDouble(),
      sugar: (json['sugar_g'] ?? 0.0).toDouble(),
      fiber: (json['fiber_g'] ?? 0.0).toDouble(),
      servingSize: (json['serving_size_g'] ?? 0.0).toDouble(),
      sodium: (json['sodium_mg'] ?? 0.0).toDouble(),
      potassium: (json['potassium_mg'] ?? 0.0).toDouble(),
      saturatedFat: (json['fat_saturated_g'] ?? 0.0).toDouble(),
      cholesterol: (json['cholesterol_mg'] ?? 0.0).toDouble(),
    );
  }
}
