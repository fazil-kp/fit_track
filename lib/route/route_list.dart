import 'package:fit_track/model/route_model.dart';
import 'package:fit_track/view/food/food_search_screen.dart';
import 'package:fit_track/view/insight_placeholder.dart';

const String searchMain = "search-main";

List<RouteModel> mainRouteList = [
  const RouteModel(id: 0, name: "Food", darkSvg: 'assets/icons/home_fill.svg', lightSvg: 'assets/icons/home_light.svg', routeName: searchMain, widget: FitTrackPlaceHolder(enableBackButton: true, enableBottomNav: true, child: FoodSearchScreen())),
];
