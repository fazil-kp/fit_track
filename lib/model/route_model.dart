import 'package:fit_track/helper/converter.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../gen/route_model.freezed.dart';
part '../gen/route_model.g.dart';

@freezed
class RouteModel with _$RouteModel {
  const factory RouteModel({
    int? id,
    String? name,
    String? svg,
    String? lightSvg,
    String? darkSvg,
    String? routeName,
    @WidgetConverter() Widget? widget,
    @IconDataConverter() IconData? icon,
    @IconDataConverter() IconData? filledIcon,
    @IconDataConverter() IconData? lightIcon,
  }) = _RouteModel;
  factory RouteModel.fromJson(Map<String, dynamic> json) => _$RouteModelFromJson(json);
}
