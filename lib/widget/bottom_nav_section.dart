import 'package:fit_track/config/colors.dart';
import 'package:fit_track/route/bottom_routes.dart';
import 'package:fit_track/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class BottomNavSection extends StatelessWidget {
  const BottomNavSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: scaffoldColor, border: Border(top: BorderSide(color: inactiveBorder)), boxShadow: [BoxShadow(color: background, blurRadius: 2, spreadRadius: 1, offset: const Offset(0, -3))]),
      child: BottomNavigationBar(
        backgroundColor: primary,
        selectedItemColor: whiteColor,
        unselectedItemColor: whiteColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: bottomNavRouteList.map((model) {
          final currentRoute = GoRouterState.of(context).uri.toString();
          final bool isSelected = currentRoute.contains(model.routeName ?? '') || (currentRoute == '/' && model.routeName == food);
          return BottomNavigationBarItem(icon: Padding(padding: const EdgeInsets.only(bottom: 3.0), child: SvgPicture.asset(isSelected ? model.darkSvg ?? '' : model.lightSvg ?? '', color: whiteColor, width: 20, height: 20)), label: model.name ?? '');
        }).toList(),
        onTap: (index) => routeX.goNamed(bottomNavRouteList[index].routeName ?? food),
      ),
    );
  }
}
