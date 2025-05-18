import 'package:fit_track/config/colors.dart';
import 'package:fit_track/config/theme.dart';
import 'package:fit_track/helper/extensions.dart';
import 'package:fit_track/view/food/food_search_screen.dart';
import 'package:fit_track/widget/bottom_nav_section.dart';
import 'package:fit_track/widget/smart_region.dart';
import 'package:flutter/material.dart';

class FitTrackPlaceHolder extends StatelessWidget {
  final Widget? child;
  final Widget? floatingActionButton;
  final String? title;
  final bool? enableSafeArea;
  final bool? enableBackButton;
  final bool? enableBottomNav;
  const FitTrackPlaceHolder({super.key, this.child, this.enableSafeArea = true, this.enableBottomNav = true, this.title, this.enableBackButton = true, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: enableSafeArea ?? false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: SmartRegion(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        if (enableBackButton == true) ...[Icon(Icons.arrow_back_ios_new, color: primary, size: 20), 8.width],
                        Text(title ?? "", style: context.bodySmall?.copyWith(color: primary, fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(child: Container(decoration: BoxDecoration(color: scaffoldColor), child: child ?? const FoodSearchScreen())),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: enableBottomNav ?? true ? const BottomNavSection() : null,
    );
  }
}
