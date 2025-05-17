import 'package:fit_track/helper/fit_track_helper.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class WidgetConverter extends JsonConverter<Widget, String> {
  const WidgetConverter();

  @override
  Widget fromJson(String json) {
    return Container(color: Colors.red, child: Center(child: Text(json)));
  }

  @override
  String toJson(Widget object) {
    return object.toString();
  }
}

class FunctionConverter implements JsonConverter<Function, String> {
  const FunctionConverter();

  @override
  Function fromJson(String json) {
    return () => logX('This is a function');
  }

  @override
  String toJson(Function object) {
    return object.toString();
  }
}

class FunctionDynamicConverter implements JsonConverter<Function(dynamic), String> {
  const FunctionDynamicConverter();

  @override
  Function(dynamic) fromJson(String json) {
    return (dynamic arg) => logX('This is a dynamic function with arg: $arg');
  }

  @override
  String toJson(Function(dynamic) object) {
    return object.toString();
  }
}

typedef StringCallback = void Function(String);

var stringFunctionMap = {'printValue': (String value) => debugPrint('Value: $value'), 'showToast': (String value) => debugPrint('Showing toast with: $value')};

class IconDataConverter implements JsonConverter<IconData, String> {
  const IconDataConverter();

  @override
  IconData fromJson(String json) {
    return IconData(int.parse(json), fontFamily: 'MaterialIcons');
  }

  @override
  String toJson(IconData object) {
    return object.codePoint.toString();
  }
}

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    return Colors.red;
  }

  @override
  String toJson(Color object) {
    return object.toString();
  }
}
