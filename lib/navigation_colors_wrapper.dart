import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationColorsWrapper extends StatelessWidget {
  final Widget child;
  final Color navigationBarColor;
  final Color statusBarColor;

  final Brightness navigationBarBrightness;
  final Brightness statusBarBrightness;
  final Brightness statusBarIconBrightness;
  final Brightness navigationIconBrightness;
  const NavigationColorsWrapper({
    super.key,
    required this.child,
    this.navigationBarColor = Colors.white,
    this.statusBarColor = Colors.transparent,
    this.navigationBarBrightness = Brightness.dark,
    this.statusBarBrightness = Brightness.dark,
    this.statusBarIconBrightness = Brightness.dark,
    this.navigationIconBrightness = Brightness.dark,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: statusBarColor,
            systemNavigationBarColor: navigationBarColor,
            systemNavigationBarIconBrightness: navigationIconBrightness,
            statusBarBrightness: statusBarBrightness,
            statusBarIconBrightness: statusBarIconBrightness,
            systemStatusBarContrastEnforced: false,
            systemNavigationBarContrastEnforced: false),
        child: child);
  }
}
