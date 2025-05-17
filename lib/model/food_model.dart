import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part '../gen/food_model.freezed.dart';
part '../gen/food_model.g.dart';
// part '../gen/food_model.hive.g.dart';

@freezed
@HiveType(typeId: 0)
class Food with _$Food {
  const factory Food({
    @HiveField(0) @JsonKey(name: 'name', defaultValue: 'Unknown') String? label,
    @HiveField(1) @JsonKey(defaultValue: 0.0) required double? calories,
    @HiveField(2) @JsonKey(name: 'protein_g', defaultValue: 0.0) double? protein,
    @HiveField(3) @JsonKey(name: 'fat_total_g', defaultValue: 0.0) double? fat,
    @HiveField(4) @JsonKey(name: 'carbohydrates_total_g', defaultValue: 0.0) double? carbs,
    @HiveField(5) @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugar,
    @HiveField(6) @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiber,
    @HiveField(7) @JsonKey(name: 'serving_size_g', defaultValue: 0.0) double? servingSize,
    @HiveField(8) @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodium,
    @HiveField(9) @JsonKey(name: 'potassium_mg', defaultValue: 0.0) double? potassium,
    @HiveField(10) @JsonKey(name: 'fat_saturated_g', defaultValue: 0.0) double? saturatedFat,
    @HiveField(11) @JsonKey(name: 'cholesterol_mg', defaultValue: 0.0) double? cholesterol,
  }) = _Food;

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
}