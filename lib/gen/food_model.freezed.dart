// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../model/food_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Food _$FoodFromJson(Map<String, dynamic> json) {
  return _Food.fromJson(json);
}

/// @nodoc
mixin _$Food {
  @HiveField(0)
  @JsonKey(name: 'name', defaultValue: 'Unknown')
  String? get label => throw _privateConstructorUsedError;
  @HiveField(1)
  @JsonKey(defaultValue: 0.0)
  double? get calories => throw _privateConstructorUsedError;
  @HiveField(2)
  @JsonKey(name: 'protein_g', defaultValue: 0.0)
  double? get protein => throw _privateConstructorUsedError;
  @HiveField(3)
  @JsonKey(name: 'fat_total_g', defaultValue: 0.0)
  double? get fat => throw _privateConstructorUsedError;
  @HiveField(4)
  @JsonKey(name: 'carbohydrates_total_g', defaultValue: 0.0)
  double? get carbs => throw _privateConstructorUsedError;
  @HiveField(5)
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  double? get sugar => throw _privateConstructorUsedError;
  @HiveField(6)
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  double? get fiber => throw _privateConstructorUsedError;
  @HiveField(7)
  @JsonKey(name: 'serving_size_g', defaultValue: 0.0)
  double? get servingSize => throw _privateConstructorUsedError;
  @HiveField(8)
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  double? get sodium => throw _privateConstructorUsedError;
  @HiveField(9)
  @JsonKey(name: 'potassium_mg', defaultValue: 0.0)
  double? get potassium => throw _privateConstructorUsedError;
  @HiveField(10)
  @JsonKey(name: 'fat_saturated_g', defaultValue: 0.0)
  double? get saturatedFat => throw _privateConstructorUsedError;
  @HiveField(11)
  @JsonKey(name: 'cholesterol_mg', defaultValue: 0.0)
  double? get cholesterol => throw _privateConstructorUsedError;

  /// Serializes this Food to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodCopyWith<Food> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodCopyWith<$Res> {
  factory $FoodCopyWith(Food value, $Res Function(Food) then) =
      _$FoodCopyWithImpl<$Res, Food>;
  @useResult
  $Res call(
      {@HiveField(0)
      @JsonKey(name: 'name', defaultValue: 'Unknown')
      String? label,
      @HiveField(1) @JsonKey(defaultValue: 0.0) double? calories,
      @HiveField(2)
      @JsonKey(name: 'protein_g', defaultValue: 0.0)
      double? protein,
      @HiveField(3)
      @JsonKey(name: 'fat_total_g', defaultValue: 0.0)
      double? fat,
      @HiveField(4)
      @JsonKey(name: 'carbohydrates_total_g', defaultValue: 0.0)
      double? carbs,
      @HiveField(5) @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugar,
      @HiveField(6) @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiber,
      @HiveField(7)
      @JsonKey(name: 'serving_size_g', defaultValue: 0.0)
      double? servingSize,
      @HiveField(8)
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
      double? sodium,
      @HiveField(9)
      @JsonKey(name: 'potassium_mg', defaultValue: 0.0)
      double? potassium,
      @HiveField(10)
      @JsonKey(name: 'fat_saturated_g', defaultValue: 0.0)
      double? saturatedFat,
      @HiveField(11)
      @JsonKey(name: 'cholesterol_mg', defaultValue: 0.0)
      double? cholesterol});
}

/// @nodoc
class _$FoodCopyWithImpl<$Res, $Val extends Food>
    implements $FoodCopyWith<$Res> {
  _$FoodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? calories = freezed,
    Object? protein = freezed,
    Object? fat = freezed,
    Object? carbs = freezed,
    Object? sugar = freezed,
    Object? fiber = freezed,
    Object? servingSize = freezed,
    Object? sodium = freezed,
    Object? potassium = freezed,
    Object? saturatedFat = freezed,
    Object? cholesterol = freezed,
  }) {
    return _then(_value.copyWith(
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      protein: freezed == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double?,
      fat: freezed == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double?,
      carbs: freezed == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double?,
      sugar: freezed == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double?,
      fiber: freezed == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double?,
      servingSize: freezed == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as double?,
      sodium: freezed == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double?,
      potassium: freezed == potassium
          ? _value.potassium
          : potassium // ignore: cast_nullable_to_non_nullable
              as double?,
      saturatedFat: freezed == saturatedFat
          ? _value.saturatedFat
          : saturatedFat // ignore: cast_nullable_to_non_nullable
              as double?,
      cholesterol: freezed == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodImplCopyWith<$Res> implements $FoodCopyWith<$Res> {
  factory _$$FoodImplCopyWith(
          _$FoodImpl value, $Res Function(_$FoodImpl) then) =
      __$$FoodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0)
      @JsonKey(name: 'name', defaultValue: 'Unknown')
      String? label,
      @HiveField(1) @JsonKey(defaultValue: 0.0) double? calories,
      @HiveField(2)
      @JsonKey(name: 'protein_g', defaultValue: 0.0)
      double? protein,
      @HiveField(3)
      @JsonKey(name: 'fat_total_g', defaultValue: 0.0)
      double? fat,
      @HiveField(4)
      @JsonKey(name: 'carbohydrates_total_g', defaultValue: 0.0)
      double? carbs,
      @HiveField(5) @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugar,
      @HiveField(6) @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiber,
      @HiveField(7)
      @JsonKey(name: 'serving_size_g', defaultValue: 0.0)
      double? servingSize,
      @HiveField(8)
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
      double? sodium,
      @HiveField(9)
      @JsonKey(name: 'potassium_mg', defaultValue: 0.0)
      double? potassium,
      @HiveField(10)
      @JsonKey(name: 'fat_saturated_g', defaultValue: 0.0)
      double? saturatedFat,
      @HiveField(11)
      @JsonKey(name: 'cholesterol_mg', defaultValue: 0.0)
      double? cholesterol});
}

/// @nodoc
class __$$FoodImplCopyWithImpl<$Res>
    extends _$FoodCopyWithImpl<$Res, _$FoodImpl>
    implements _$$FoodImplCopyWith<$Res> {
  __$$FoodImplCopyWithImpl(_$FoodImpl _value, $Res Function(_$FoodImpl) _then)
      : super(_value, _then);

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = freezed,
    Object? calories = freezed,
    Object? protein = freezed,
    Object? fat = freezed,
    Object? carbs = freezed,
    Object? sugar = freezed,
    Object? fiber = freezed,
    Object? servingSize = freezed,
    Object? sodium = freezed,
    Object? potassium = freezed,
    Object? saturatedFat = freezed,
    Object? cholesterol = freezed,
  }) {
    return _then(_$FoodImpl(
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double?,
      protein: freezed == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double?,
      fat: freezed == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double?,
      carbs: freezed == carbs
          ? _value.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double?,
      sugar: freezed == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double?,
      fiber: freezed == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double?,
      servingSize: freezed == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as double?,
      sodium: freezed == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double?,
      potassium: freezed == potassium
          ? _value.potassium
          : potassium // ignore: cast_nullable_to_non_nullable
              as double?,
      saturatedFat: freezed == saturatedFat
          ? _value.saturatedFat
          : saturatedFat // ignore: cast_nullable_to_non_nullable
              as double?,
      cholesterol: freezed == cholesterol
          ? _value.cholesterol
          : cholesterol // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodImpl implements _Food {
  const _$FoodImpl(
      {@HiveField(0) @JsonKey(name: 'name', defaultValue: 'Unknown') this.label,
      @HiveField(1) @JsonKey(defaultValue: 0.0) required this.calories,
      @HiveField(2) @JsonKey(name: 'protein_g', defaultValue: 0.0) this.protein,
      @HiveField(3) @JsonKey(name: 'fat_total_g', defaultValue: 0.0) this.fat,
      @HiveField(4)
      @JsonKey(name: 'carbohydrates_total_g', defaultValue: 0.0)
      this.carbs,
      @HiveField(5) @JsonKey(name: 'sugar_g', defaultValue: 0.0) this.sugar,
      @HiveField(6) @JsonKey(name: 'fiber_g', defaultValue: 0.0) this.fiber,
      @HiveField(7)
      @JsonKey(name: 'serving_size_g', defaultValue: 0.0)
      this.servingSize,
      @HiveField(8) @JsonKey(name: 'sodium_mg', defaultValue: 0.0) this.sodium,
      @HiveField(9)
      @JsonKey(name: 'potassium_mg', defaultValue: 0.0)
      this.potassium,
      @HiveField(10)
      @JsonKey(name: 'fat_saturated_g', defaultValue: 0.0)
      this.saturatedFat,
      @HiveField(11)
      @JsonKey(name: 'cholesterol_mg', defaultValue: 0.0)
      this.cholesterol});

  factory _$FoodImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodImplFromJson(json);

  @override
  @HiveField(0)
  @JsonKey(name: 'name', defaultValue: 'Unknown')
  final String? label;
  @override
  @HiveField(1)
  @JsonKey(defaultValue: 0.0)
  final double? calories;
  @override
  @HiveField(2)
  @JsonKey(name: 'protein_g', defaultValue: 0.0)
  final double? protein;
  @override
  @HiveField(3)
  @JsonKey(name: 'fat_total_g', defaultValue: 0.0)
  final double? fat;
  @override
  @HiveField(4)
  @JsonKey(name: 'carbohydrates_total_g', defaultValue: 0.0)
  final double? carbs;
  @override
  @HiveField(5)
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  final double? sugar;
  @override
  @HiveField(6)
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  final double? fiber;
  @override
  @HiveField(7)
  @JsonKey(name: 'serving_size_g', defaultValue: 0.0)
  final double? servingSize;
  @override
  @HiveField(8)
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  final double? sodium;
  @override
  @HiveField(9)
  @JsonKey(name: 'potassium_mg', defaultValue: 0.0)
  final double? potassium;
  @override
  @HiveField(10)
  @JsonKey(name: 'fat_saturated_g', defaultValue: 0.0)
  final double? saturatedFat;
  @override
  @HiveField(11)
  @JsonKey(name: 'cholesterol_mg', defaultValue: 0.0)
  final double? cholesterol;

  @override
  String toString() {
    return 'Food(label: $label, calories: $calories, protein: $protein, fat: $fat, carbs: $carbs, sugar: $sugar, fiber: $fiber, servingSize: $servingSize, sodium: $sodium, potassium: $potassium, saturatedFat: $saturatedFat, cholesterol: $cholesterol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.sugar, sugar) || other.sugar == sugar) &&
            (identical(other.fiber, fiber) || other.fiber == fiber) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            (identical(other.sodium, sodium) || other.sodium == sodium) &&
            (identical(other.potassium, potassium) ||
                other.potassium == potassium) &&
            (identical(other.saturatedFat, saturatedFat) ||
                other.saturatedFat == saturatedFat) &&
            (identical(other.cholesterol, cholesterol) ||
                other.cholesterol == cholesterol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      label,
      calories,
      protein,
      fat,
      carbs,
      sugar,
      fiber,
      servingSize,
      sodium,
      potassium,
      saturatedFat,
      cholesterol);

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodImplCopyWith<_$FoodImpl> get copyWith =>
      __$$FoodImplCopyWithImpl<_$FoodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodImplToJson(
      this,
    );
  }
}

abstract class _Food implements Food {
  const factory _Food(
      {@HiveField(0)
      @JsonKey(name: 'name', defaultValue: 'Unknown')
      final String? label,
      @HiveField(1) @JsonKey(defaultValue: 0.0) required final double? calories,
      @HiveField(2)
      @JsonKey(name: 'protein_g', defaultValue: 0.0)
      final double? protein,
      @HiveField(3)
      @JsonKey(name: 'fat_total_g', defaultValue: 0.0)
      final double? fat,
      @HiveField(4)
      @JsonKey(name: 'carbohydrates_total_g', defaultValue: 0.0)
      final double? carbs,
      @HiveField(5)
      @JsonKey(name: 'sugar_g', defaultValue: 0.0)
      final double? sugar,
      @HiveField(6)
      @JsonKey(name: 'fiber_g', defaultValue: 0.0)
      final double? fiber,
      @HiveField(7)
      @JsonKey(name: 'serving_size_g', defaultValue: 0.0)
      final double? servingSize,
      @HiveField(8)
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
      final double? sodium,
      @HiveField(9)
      @JsonKey(name: 'potassium_mg', defaultValue: 0.0)
      final double? potassium,
      @HiveField(10)
      @JsonKey(name: 'fat_saturated_g', defaultValue: 0.0)
      final double? saturatedFat,
      @HiveField(11)
      @JsonKey(name: 'cholesterol_mg', defaultValue: 0.0)
      final double? cholesterol}) = _$FoodImpl;

  factory _Food.fromJson(Map<String, dynamic> json) = _$FoodImpl.fromJson;

  @override
  @HiveField(0)
  @JsonKey(name: 'name', defaultValue: 'Unknown')
  String? get label;
  @override
  @HiveField(1)
  @JsonKey(defaultValue: 0.0)
  double? get calories;
  @override
  @HiveField(2)
  @JsonKey(name: 'protein_g', defaultValue: 0.0)
  double? get protein;
  @override
  @HiveField(3)
  @JsonKey(name: 'fat_total_g', defaultValue: 0.0)
  double? get fat;
  @override
  @HiveField(4)
  @JsonKey(name: 'carbohydrates_total_g', defaultValue: 0.0)
  double? get carbs;
  @override
  @HiveField(5)
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  double? get sugar;
  @override
  @HiveField(6)
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  double? get fiber;
  @override
  @HiveField(7)
  @JsonKey(name: 'serving_size_g', defaultValue: 0.0)
  double? get servingSize;
  @override
  @HiveField(8)
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  double? get sodium;
  @override
  @HiveField(9)
  @JsonKey(name: 'potassium_mg', defaultValue: 0.0)
  double? get potassium;
  @override
  @HiveField(10)
  @JsonKey(name: 'fat_saturated_g', defaultValue: 0.0)
  double? get saturatedFat;
  @override
  @HiveField(11)
  @JsonKey(name: 'cholesterol_mg', defaultValue: 0.0)
  double? get cholesterol;

  /// Create a copy of Food
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodImplCopyWith<_$FoodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
