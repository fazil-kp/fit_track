import 'dart:io';

import 'package:fit_track/config/colors.dart';
import 'package:fit_track/helper/fit_track_helper.dart';
import 'package:fit_track/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(ProviderScope(child: Insights()));
}

class Insights extends StatelessWidget {
  const Insights({super.key});
  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(colorScheme: lightColorScheme);
    initTheme(themeData);
    return MaterialApp.router(
      routerConfig: routeX,
      title: 'Insight',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
      themeMode: ThemeMode.light,
      theme: themeData,
      darkTheme: ThemeData(colorScheme: darkColorScheme),
    );
  }
}
