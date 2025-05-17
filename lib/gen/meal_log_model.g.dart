// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/meal_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealLogAdapter extends TypeAdapter<MealLog> {
  @override
  final int typeId = 1;

  @override
  MealLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealLog(
      date: fields[0] as DateTime,
      foods: (fields[1] as List).cast<Food>(),
    );
  }

  @override
  void write(BinaryWriter writer, MealLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.foods);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealLogImpl _$$MealLogImplFromJson(Map<String, dynamic> json) =>
    _$MealLogImpl(
      date: DateTime.parse(json['date'] as String),
      foods: (json['foods'] as List<dynamic>)
          .map((e) => Food.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MealLogImplToJson(_$MealLogImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'foods': instance.foods,
    };
