import 'package:fit_track/model/route_model.dart';
import 'package:fit_track/view/food/food_search_screen.dart';
import 'package:fit_track/view/insight_placeholder.dart';
import 'package:fit_track/view/progress/progress_screen.dart';

const String food = "food";
const String meal = "meal";
const String progress = "progress";

List<RouteModel> bottomNavRouteList = [
  RouteModel(id: 0, name: "Food", darkSvg: 'assets/icons/home_fill.svg', lightSvg: 'assets/icons/home_light.svg', routeName: food, widget: FitTrackPlaceHolder(title: "Home", enableBackButton: false, child: FoodSearchScreen())),
  RouteModel(id: 1, name: "Meal", darkSvg: 'assets/icons/home_fill.svg', lightSvg: 'assets/icons/home_light.svg', routeName: meal, widget: FitTrackPlaceHolder(child: ProgressScreen())),
  RouteModel(id: 2, name: "Progress", darkSvg: 'assets/icons/home_fill.svg', lightSvg: 'assets/icons/home_light.svg', routeName: progress, widget: FitTrackPlaceHolder(child: ProgressScreen())),
];
