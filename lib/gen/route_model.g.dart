// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RouteModelImpl _$$RouteModelImplFromJson(Map<String, dynamic> json) =>
    _$RouteModelImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      svg: json['svg'] as String?,
      lightSvg: json['lightSvg'] as String?,
      darkSvg: json['darkSvg'] as String?,
      routeName: json['routeName'] as String?,
      widget: _$JsonConverterFromJson<String, Widget>(
          json['widget'], const WidgetConverter().fromJson),
      icon: _$JsonConverterFromJson<String, IconData>(
          json['icon'], const IconDataConverter().fromJson),
      filledIcon: _$JsonConverterFromJson<String, IconData>(
          json['filledIcon'], const IconDataConverter().fromJson),
      lightIcon: _$JsonConverterFromJson<String, IconData>(
          json['lightIcon'], const IconDataConverter().fromJson),
    );

Map<String, dynamic> _$$RouteModelImplToJson(_$RouteModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'svg': instance.svg,
      'lightSvg': instance.lightSvg,
      'darkSvg': instance.darkSvg,
      'routeName': instance.routeName,
      'widget': _$JsonConverterToJson<String, Widget>(
          instance.widget, const WidgetConverter().toJson),
      'icon': _$JsonConverterToJson<String, IconData>(
          instance.icon, const IconDataConverter().toJson),
      'filledIcon': _$JsonConverterToJson<String, IconData>(
          instance.filledIcon, const IconDataConverter().toJson),
      'lightIcon': _$JsonConverterToJson<String, IconData>(
          instance.lightIcon, const IconDataConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
