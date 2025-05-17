import 'package:flutter/material.dart';

late ThemeData theme;

void initTheme(ThemeData newTheme) {
  theme = newTheme;
}

Color get scaffoldColor => theme.colorScheme.surface;
Color get background => theme.colorScheme.surface;
Color get primary => theme.colorScheme.tertiary;
Color get justPrimary => theme.colorScheme.primary;
Color get navBarColor => theme.colorScheme.secondary;
Color get inactiveBorder => theme.colorScheme.outline;
Color get activeBorder => theme.colorScheme.outlineVariant;
Color get cardBackground => theme.colorScheme.onPrimary;
Color get ashWhiteLabel => theme.colorScheme.onPrimaryContainer;
Color get ashColor => theme.colorScheme.primaryContainer;
Color get whiteColor => theme.colorScheme.surface;
Color get blackColor => theme.colorScheme.onSurface;

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  surface: Color(0XFFFFFFFF),
  primary: Color(0XFF557669),
  secondary: Color(0XFF58a184),
  outline: Color.fromARGB(255, 21, 128, 44),
  outlineVariant: Color(0xFF727a8e),
  onPrimaryContainer: Color(0XFF9F9F9F),
  onTertiary: Color(0xFF8b91a8),
  onPrimary: Color(0xFF212227),
  primaryContainer: Color.fromARGB(255, 238, 238, 238),
  tertiary: Color(0XFF297959),
  onSecondary: Color(0xFFFFFFFF),
  onSurface: Color(0xFF000000),
  error: Color(0xFFEA1505),
  onError: Color(0xFFFFFFFF),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  surface: Color(0XFFFFFFFF),
  primary: Color(0XFFFFFFFF),
  secondary: Color(0xFF00286B),
  outline: Color(0xFF202227),
  outlineVariant: Color(0xFF727a8e),
  tertiary: Color(0xFFe1e5f0),
  onTertiary: Color(0xFF8b91a8),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFFFFF),
  onPrimaryContainer: Color(0xFFFFFFFF),
  onSecondary: Color(0xFFFFFFFF),
  onSurface: Color(0xFF000000),
  error: Color(0xFFEA1505),
  onError: Color(0xFFFFFFFF),
);
