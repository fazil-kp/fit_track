import 'package:fit_track/helper/constants.dart';
import 'package:fit_track/route/bottom_routes.dart';
import 'package:fit_track/view/insight_placeholder.dart';
import 'package:fit_track/widget/no_route_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter routeX = GoRouter(initialLocation: "/", redirectLimit: 3, errorBuilder: (context, state) => const NoRouteScreen(), navigatorKey: ConstanceData.navigatorKey, routes: buildRoutes());

List<RouteBase> buildRoutes() {
  return [
    GoRoute(
      path: '/',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation), child: child);
          },
          child: FitTrackPlaceHolder(),
        );
      },
      routes: [...bottomRoutes()],
    ),
  ];
}

List<GoRoute> bottomRoutes() {
  List<GoRoute> mainRouteX = [];
  for (var route in bottomNavRouteList) {
    if (route.routeName != null && route.widget != null) {
      mainRouteX.add(
        GoRoute(
          path: route.routeName!,
          name: route.routeName,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              key: state.pageKey,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation), child: child);
              },
              child: route.widget!,
            );
          },
        ),
      );
    }
  }
  return mainRouteX;
}
