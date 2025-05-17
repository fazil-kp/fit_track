import 'package:fit_track/config/colors.dart';
import 'package:flutter/material.dart';

abstract class ThemeStyle {
  Brightness get brightness;
  final Typography _typography = Typography.material2021();
  final ThemeMode mode;
  ColorScheme get colorScheme;
  TextTheme get textTheme;
  ThemeStyle(this.mode);
}

extension ThemeExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleLarge => textTheme.titleLarge;
}

extension CopyWithTextTheme on TextTheme {
  TextTheme copyWithTextTheme({Color? color, ColorScheme? colorScheme}) {
    String fontFamily = "Inter";

    return copyWith(
      bodySmall: bodySmall?.copyWith(color: colorScheme?.onSurface ?? color, fontFamily: fontFamily, fontSize: 12),
      bodyMedium: bodyMedium?.copyWith(color: colorScheme?.onSurface ?? color, fontFamily: fontFamily, fontSize: 14),
      bodyLarge: bodyLarge?.copyWith(color: colorScheme?.onSurface ?? color, fontFamily: fontFamily, fontSize: 16),
    );
  }
}

class LightThemeStyle extends ThemeStyle {
  LightThemeStyle() : super(ThemeMode.light);

  @override
  ColorScheme get colorScheme => lightColorScheme;

  @override
  TextTheme get textTheme => _typography.englishLike.copyWithTextTheme(colorScheme: colorScheme);

  @override
  Brightness get brightness => Brightness.light;
}

class DarkThemeStyle extends ThemeStyle {
  @override
  ColorScheme get colorScheme => darkColorScheme;

  DarkThemeStyle() : super(ThemeMode.dark);

  @override
  TextTheme get textTheme => _typography.englishLike.copyWithTextTheme(colorScheme: colorScheme);

  @override
  Brightness get brightness => Brightness.dark;
}

class AppTheme {
  static final Typography _typography = Typography.material2021();

  static ThemeData getThemeData(ThemeMode mode) {
    final data = mode == ThemeMode.light ? LightThemeStyle() : DarkThemeStyle();
    return ThemeData(
      brightness: data.brightness,
      useMaterial3: true,
      tooltipTheme: TooltipThemeData(textStyle: data.textTheme.bodySmall?.copyWith(color: Colors.white), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8))),
      textSelectionTheme: TextSelectionThemeData(cursorColor: data.colorScheme.primary, selectionColor: data.colorScheme.primary),
      dialogBackgroundColor: data.colorScheme.surface,
      colorScheme: data.colorScheme,
      typography: _typography,
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(iconSize: 30, foregroundColor: data.colorScheme.primary)),
      checkboxTheme: CheckboxThemeData(side: const BorderSide(color: Color(0XFF757474)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
      iconTheme: IconThemeData(color: data.colorScheme.onSurface, size: 30),
      cardTheme: CardTheme(surfaceTintColor: data.colorScheme.surface, color: data.colorScheme.surface, margin: const EdgeInsets.all(8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      expansionTileTheme: ExpansionTileThemeData(backgroundColor: data.colorScheme.surface, collapsedBackgroundColor: data.colorScheme.surface),
      elevatedButtonTheme: _buttonStyle(data.colorScheme, data.textTheme),
      outlinedButtonTheme: _outlineStyle(data.colorScheme, data.textTheme),
      cardColor: data.colorScheme.surface,
      listTileTheme: ListTileThemeData(tileColor: data.colorScheme.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return 5;
          }
          return 5;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return data.colorScheme.primary;
          }
          return data.colorScheme.primary;
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(suffixIconColor: data.colorScheme.primary, floatingLabelBehavior: FloatingLabelBehavior.always, contentPadding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12), isDense: true, filled: true, fillColor: data.colorScheme.inversePrimary, errorStyle: data.textTheme.bodySmall?.copyWith(color: data.colorScheme.error), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: data.colorScheme.tertiary), gapPadding: 0, borderRadius: BorderRadius.circular(8)), prefixIconColor: data.colorScheme.outline, enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: data.colorScheme.tertiary), gapPadding: 0, borderRadius: BorderRadius.circular(8)), labelStyle: data.textTheme.bodyMedium?.copyWith(color: data.colorScheme.secondary), border: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: data.colorScheme.tertiary), gapPadding: 0, borderRadius: BorderRadius.circular(8))),
      textTheme: data.textTheme,
      dialogTheme: DialogTheme(backgroundColor: data.colorScheme.surface, elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), contentTextStyle: data.textTheme.bodySmall, titleTextStyle: data.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      drawerTheme: DrawerThemeData(backgroundColor: data.colorScheme.primary, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), topRight: Radius.circular(30)))),
      dividerTheme: DividerThemeData(thickness: 0.8, color: data.colorScheme.outline),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      scaffoldBackgroundColor: data.colorScheme.surface,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: data.colorScheme.surface, selectedIconTheme: IconThemeData(color: data.colorScheme.secondary, size: 30), unselectedIconTheme: IconThemeData(color: data.colorScheme.outline, size: 25), selectedLabelStyle: const TextStyle(color: Colors.green), selectedItemColor: data.colorScheme.secondary, showUnselectedLabels: true, showSelectedLabels: false, unselectedItemColor: data.colorScheme.outline, unselectedLabelStyle: const TextStyle(fontSize: 10), type: BottomNavigationBarType.fixed),
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.red, indicatorColor: Colors.red),
    );
  }

  static ThemeData reverseThemeData(ThemeData data) {
    return data.copyWith(textTheme: data.textTheme.copyWithTextTheme(color: data.colorScheme.onSurfaceVariant), colorScheme: data.colorScheme.copyWith(surface: data.colorScheme.surfaceContainerHighest, onSurface: data.colorScheme.onSurfaceVariant), scaffoldBackgroundColor: data.colorScheme.surfaceContainerHighest, inputDecorationTheme: data.inputDecorationTheme.copyWith(filled: true));
  }

  static ThemeData gradientTheme(ThemeData data) {
    return data.copyWith(iconTheme: data.iconTheme.copyWith(color: data.colorScheme.onPrimary), textTheme: data.textTheme.copyWithTextTheme(color: data.colorScheme.onPrimary));
  }

  static ElevatedButtonThemeData _buttonStyle(ColorScheme colorScheme, TextTheme textTheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: colorScheme.onPrimary, backgroundColor: colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), textStyle: textTheme.bodyMedium),
    );
  }

  static OutlinedButtonThemeData _outlineStyle(ColorScheme colorScheme, TextTheme textTheme) {
    return OutlinedButtonThemeData(
      style: ElevatedButton.styleFrom(foregroundColor: colorScheme.onPrimary, shape: RoundedRectangleBorder(side: BorderSide(color: colorScheme.primary, width: 20, strokeAlign: 20), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15), textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
