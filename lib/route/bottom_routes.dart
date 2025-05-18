import 'package:fit_track/model/route_model.dart';
import 'package:fit_track/view/food/food_search_screen.dart';
import 'package:fit_track/view/insight_placeholder.dart';
import 'package:fit_track/view/meal/meal_log_screen.dart';
import 'package:fit_track/view/progress/progress_screen.dart';

const String home = "home";
const String meal = "meal";
const String progress = "progress";

List<RouteModel> bottomNavRouteList = [
  const RouteModel(id: 0, name: "Home", darkSvg: 'assets/icons/home_fill.svg', lightSvg: 'assets/icons/home_light.svg', routeName: home, widget: FitTrackPlaceHolder(enableBackButton: false, child: FoodSearchScreen())),
  const RouteModel(id: 1, name: "Meal", darkSvg: 'assets/icons/meal_fill.svg', lightSvg: 'assets/icons/meal_light.svg', routeName: meal, widget: MealLogScreen()),
  const RouteModel(id: 2, name: "Progress", darkSvg: 'assets/icons/progress_fill.svg', lightSvg: 'assets/icons/progress_light.svg', routeName: progress, widget: FitTrackPlaceHolder(child: ProgressScreen())),
];
