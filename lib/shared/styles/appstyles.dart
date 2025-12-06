import 'package:flutter/material.dart';

class AppStyles {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 950;
  }
  
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 900 && width < 1000;
  }
  
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1000;
  }
}