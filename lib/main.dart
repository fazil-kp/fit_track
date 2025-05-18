import 'dart:io';
import 'package:fit_track/config/colors.dart';
import 'package:fit_track/helper/fit_track_helper.dart';
import 'package:fit_track/model/food_model.dart';
import 'package:fit_track/model/meal_log_model.dart';
import 'package:fit_track/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

//Todo:
//! For interview purposes, the .env file is NOT added , so you can see the api in api_service.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(MealLogAdapter());
  await Hive.openBox<MealLog>('mealLogs');
  HttpOverrides.global = MyHttpOverrides();
  runApp(const ProviderScope(child: Insights()));
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
