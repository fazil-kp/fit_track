// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../model/meal_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealLog _$MealLogFromJson(Map<String, dynamic> json) {
  return _MealLog.fromJson(json);
}

/// @nodoc
mixin _$MealLog {
  @HiveField(0)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(1)
  List<Food> get foods => throw _privateConstructorUsedError;

  /// Serializes this MealLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealLogCopyWith<MealLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealLogCopyWith<$Res> {
  factory $MealLogCopyWith(MealLog value, $Res Function(MealLog) then) =
      _$MealLogCopyWithImpl<$Res, MealLog>;
  @useResult
  $Res call({@HiveField(0) DateTime date, @HiveField(1) List<Food> foods});
}

/// @nodoc
class _$MealLogCopyWithImpl<$Res, $Val extends MealLog>
    implements $MealLogCopyWith<$Res> {
  _$MealLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? foods = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      foods: null == foods
          ? _value.foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<Food>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealLogImplCopyWith<$Res> implements $MealLogCopyWith<$Res> {
  factory _$$MealLogImplCopyWith(
          _$MealLogImpl value, $Res Function(_$MealLogImpl) then) =
      __$$MealLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) DateTime date, @HiveField(1) List<Food> foods});
}

/// @nodoc
class __$$MealLogImplCopyWithImpl<$Res>
    extends _$MealLogCopyWithImpl<$Res, _$MealLogImpl>
    implements _$$MealLogImplCopyWith<$Res> {
  __$$MealLogImplCopyWithImpl(
      _$MealLogImpl _value, $Res Function(_$MealLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? foods = null,
  }) {
    return _then(_$MealLogImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      foods: null == foods
          ? _value._foods
          : foods // ignore: cast_nullable_to_non_nullable
              as List<Food>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealLogImpl implements _MealLog {
  const _$MealLogImpl(
      {@HiveField(0) required this.date,
      @HiveField(1) required final List<Food> foods})
      : _foods = foods;

  factory _$MealLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealLogImplFromJson(json);

  @override
  @HiveField(0)
  final DateTime date;
  final List<Food> _foods;
  @override
  @HiveField(1)
  List<Food> get foods {
    if (_foods is EqualUnmodifiableListView) return _foods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foods);
  }

  @override
  String toString() {
    return 'MealLog(date: $date, foods: $foods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealLogImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._foods, _foods));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(_foods));

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealLogImplCopyWith<_$MealLogImpl> get copyWith =>
      __$$MealLogImplCopyWithImpl<_$MealLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealLogImplToJson(
      this,
    );
  }
}

abstract class _MealLog implements MealLog {
  const factory _MealLog(
      {@HiveField(0) required final DateTime date,
      @HiveField(1) required final List<Food> foods}) = _$MealLogImpl;

  factory _MealLog.fromJson(Map<String, dynamic> json) = _$MealLogImpl.fromJson;

  @override
  @HiveField(0)
  DateTime get date;
  @override
  @HiveField(1)
  List<Food> get foods;

  /// Create a copy of MealLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealLogImplCopyWith<_$MealLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
