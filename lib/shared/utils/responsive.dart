import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
    textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  /// Returns true if device is a tablet (width >= 600)
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  /// Returns true if device is a small phone (width < 360)
  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  /// Get responsive width based on percentage of screen width
  static double width(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  /// Get responsive height based on percentage of screen height
  static double height(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  /// Get responsive font size that scales with screen width
  static double fontSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    // Base width is 375 (iPhone SE/small phones)
    final scaleFactor = width / 375;
    // Clamp the scale factor to prevent text from being too small or too large
    final clampedScaleFactor = scaleFactor.clamp(0.8, 1.3);
    return size * clampedScaleFactor;
  }

  /// Get responsive padding/margin based on screen width
  static double spacing(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / 375;
    final clampedScaleFactor = scaleFactor.clamp(0.85, 1.2);
    return size * clampedScaleFactor;
  }

  /// Get responsive icon size
  static double iconSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / 375;
    final clampedScaleFactor = scaleFactor.clamp(0.85, 1.2);
    return size * clampedScaleFactor;
  }

  /// Get responsive container height
  static double containerHeight(BuildContext context, double size) {
    final height = MediaQuery.of(context).size.height;
    final scaleFactor = height / 812; // Base height (iPhone X)
    final clampedScaleFactor = scaleFactor.clamp(0.8, 1.3);
    return size * clampedScaleFactor;
  }

  /// Get responsive image size
  static double imageSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / 375;
    final clampedScaleFactor = scaleFactor.clamp(0.7, 1.4);
    return size * clampedScaleFactor;
  }

  /// Get horizontal padding based on screen size
  static EdgeInsets horizontalPadding(BuildContext context, double value) {
    return EdgeInsets.symmetric(horizontal: spacing(context, value));
  }

  /// Get symmetric padding based on screen size
  static EdgeInsets symmetricPadding(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: spacing(context, horizontal),
      vertical: spacing(context, vertical),
    );
  }

  /// Get all padding based on screen size
  static EdgeInsets allPadding(BuildContext context, double value) {
    return EdgeInsets.all(spacing(context, value));
  }
}

/// Extension for easier access to responsive values
extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isTablet => screenWidth >= 600;
  bool get isSmallPhone => screenWidth < 360;

  /// Responsive font size
  double rFontSize(double size) => Responsive.fontSize(this, size);

  /// Responsive spacing (padding/margin)
  double rSpacing(double size) => Responsive.spacing(this, size);

  /// Responsive icon size
  double rIconSize(double size) => Responsive.iconSize(this, size);

  /// Responsive container height
  double rHeight(double size) => Responsive.containerHeight(this, size);

  /// Responsive image size
  double rImageSize(double size) => Responsive.imageSize(this, size);

  /// Responsive width percentage
  double widthPercent(double percent) => Responsive.width(this, percent);

  /// Responsive height percentage
  double heightPercent(double percent) => Responsive.height(this, percent);
}

