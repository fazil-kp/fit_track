import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:fit_track/model/food_model.dart';

part '../gen/meal_log_model.freezed.dart';
part '../gen/meal_log_model.g.dart';
// part '../gen/meal_log_model.hive.g.dart';

@freezed
@HiveType(typeId: 1)
class MealLog with _$MealLog {
  const factory MealLog({
    @HiveField(0) required DateTime date,
    @HiveField(1) required List<Food> foods,
  }) = _MealLog;

  factory MealLog.fromJson(Map<String, dynamic> json) => _$MealLogFromJson(json);
}
