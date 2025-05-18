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

class AppColors {
  static const Color primary = Color(0xFF297959); // New primary color as requested
  static const Color primaryLight = Color(0xFF3A8A69); // Lighter shade of primary
  static const Color primaryDark = Color(0xFF1F5D43); // Darker shade of primary
  static const Color accent = Color(0xFF4CAF50); // Complementary green
  static const Color accentLight = Color(0xFF81C784);
  static const Color textDark = Color(0xFF333333);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF); // White background as requested
  static const Color cardBackground = Color(0xFFF5F5F5); // Light grey for cards

  // Chart colors
  static const Color calories = Color(0xFF297959); // Primary color
  static const Color protein = Color(0xFF4285F4); // Blue
  static const Color fat = Color(0xFFFFA000); // Amber
  static const Color carbs = Color(0xFFDB4437); // Red

  // Meal category colors
  static const Color breakfast = Color(0xFFFF9800); // Orange
  static const Color lunch = Color(0xFF4285F4); // Blue
  static const Color dinner = Color(0xFF297959); // Primary green
  static const Color snacks = Color(0xFF9C27B0); // Purple
}
