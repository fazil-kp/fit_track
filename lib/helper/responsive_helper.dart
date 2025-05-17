import 'package:fit_track/helper/extensions.dart';
import 'package:flutter/material.dart';

class ResponsiveHelper {
  /// Checks if the current device is a mobile device.
  ///
  /// Returns true if the screen width is less than 500 pixels.
  static bool isMobile(BuildContext context) => context.width() < 500;

  /// Checks if the current device is a tablet.
  ///
  /// Returns true if the screen width is between 500 and 1024 pixels.
  static bool isTablet(BuildContext context) => context.width() >= 500 && context.width() < 1024;

  /// Checks if the current device is a desktop.
  ///
  /// Returns true if the screen width is 1024 pixels or more.
  static bool isDesktop(BuildContext context) => context.width() >= 1024;
}

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}
