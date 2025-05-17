// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/food_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodAdapter extends TypeAdapter<Food> {
  @override
  final int typeId = 0;

  @override
  Food read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Food(
      label: fields[0] as String?,
      calories: fields[1] as double?,
      protein: fields[2] as double?,
      fat: fields[3] as double?,
      carbs: fields[4] as double?,
      sugar: fields[5] as double?,
      fiber: fields[6] as double?,
      servingSize: fields[7] as double?,
      sodium: fields[8] as double?,
      potassium: fields[9] as double?,
      saturatedFat: fields[10] as double?,
      cholesterol: fields[11] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Food obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.calories)
      ..writeByte(2)
      ..write(obj.protein)
      ..writeByte(3)
      ..write(obj.fat)
      ..writeByte(4)
      ..write(obj.carbs)
      ..writeByte(5)
      ..write(obj.sugar)
      ..writeByte(6)
      ..write(obj.fiber)
      ..writeByte(7)
      ..write(obj.servingSize)
      ..writeByte(8)
      ..write(obj.sodium)
      ..writeByte(9)
      ..write(obj.potassium)
      ..writeByte(10)
      ..write(obj.saturatedFat)
      ..writeByte(11)
      ..write(obj.cholesterol);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodImpl _$$FoodImplFromJson(Map<String, dynamic> json) => _$FoodImpl(
      label: json['name'] as String? ?? 'Unknown',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein_g'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat_total_g'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbohydrates_total_g'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar_g'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber_g'] as num?)?.toDouble() ?? 0.0,
      servingSize: (json['serving_size_g'] as num?)?.toDouble() ?? 0.0,
      sodium: (json['sodium_mg'] as num?)?.toDouble() ?? 0.0,
      potassium: (json['potassium_mg'] as num?)?.toDouble() ?? 0.0,
      saturatedFat: (json['fat_saturated_g'] as num?)?.toDouble() ?? 0.0,
      cholesterol: (json['cholesterol_mg'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$FoodImplToJson(_$FoodImpl instance) =>
    <String, dynamic>{
      'name': instance.label,
      'calories': instance.calories,
      'protein_g': instance.protein,
      'fat_total_g': instance.fat,
      'carbohydrates_total_g': instance.carbs,
      'sugar_g': instance.sugar,
      'fiber_g': instance.fiber,
      'serving_size_g': instance.servingSize,
      'sodium_mg': instance.sodium,
      'potassium_mg': instance.potassium,
      'fat_saturated_g': instance.saturatedFat,
      'cholesterol_mg': instance.cholesterol,
    };
