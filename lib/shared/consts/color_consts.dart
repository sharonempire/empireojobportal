import 'package:flutter/material.dart';

class ColorConsts {
  static const Color primaryColor = Color.fromARGB(255, 13, 64, 176);
  static const Color secondaryColor = Color(0xFF4D5059);
  static const Color lightGrey = Color(0xFFE8E6E6);
  static const Color lightGrey2 = Color(0xFFF2F2F2);
  static const Color lightGrey3 = Color.fromARGB(255, 250, 249, 249);

  static const Color backgroundColorScaffold = Color(0xFFF9F9FA);
  static const Color activeColor = Color(0xFF16A249);
  static const Color textColor = Color(0xFF5D626A);
  static const Color greyContainer = Color(0xFFF5F5F5);
  static const Color textColorBlack = Color.fromARGB(255, 0, 0, 0);
  static const Color textColorRed = Color.fromARGB(255, 255, 0, 0);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color greyShade200 = Color(0xFFEEEEEE);
  static const Color greyShade300 = Color(0xFFE0E0E0);
  static const Color lightBlue = Color.fromARGB(255, 221, 238, 255);
  static const Color blue = Colors.blue;
  static const Color textBlue = Color(0xFF4285F4);

  static const Color greyShade600 = Color(0xFF6B6B6B);
  static const Color shadowColor = Color(0xFFE0E0E0);
  static const Color iconGrey = Color(0xFF9E9E9E);
  static const Color colorGreen = Color(0xFF4CAF50);
  static const Color lightGreyBackground = Color(0xFFF7F7F7);
  static const Color monthBgTestColor = Color(0xFFf0f6ff);

  // Dark mode colors
  static const Color darkBackgroundScaffold = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkGrey = Color(0xFF6B6B6B);
  static const Color darkGreyLight = Color(0xFF3A3A3A);
  static const Color darkDivider = Color(0xFF404040);
}

extension ColorConstsTheme on BuildContext {
  Color get themeWhite => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkCardColor
      : ColorConsts.white;
  Color get themeDark => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.white
      : ColorConsts.black;
  Color get themeCard => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkCardColor
      : ColorConsts.lightGrey3;

  Color get themeCardWhite => Theme.of(this).brightness == Brightness.dark
      ? const Color(0xFF2C2C2C)
      : ColorConsts.white;
  Color get themeBothWhite => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.white
      : ColorConsts.white;
  Color get themeScaffold => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkBackgroundScaffold
      : ColorConsts.white;
  Color get themeSLogin => Theme.of(this).brightness == Brightness.dark
      ? const Color.fromARGB(255, 49, 49, 49)
      : ColorConsts.white;
  Color get themeScaffoldCourse => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkBackgroundScaffold
      : ColorConsts.backgroundColorScaffold;

  Color get themeDivider => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkDivider
      : ColorConsts.greyShade300;

  Color get themeProfileBorder => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkDivider
      : const Color(0xFFA3A3A3);

  Color get themeLightGrey3 => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkGreyLight
      : ColorConsts.lightGrey3;
  Color get themeGrey600 => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.lightGrey3
      : ColorConsts.greyShade600;

  Color get themeIconGrey => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkTextSecondary
      : ColorConsts.iconGrey;

  Color get themeShadow => Theme.of(this).brightness == Brightness.dark
      ? Colors.black.withOpacity(0.5)
      : ColorConsts.shadowColor;

  double get themeShadowOpacity =>
      Theme.of(this).brightness == Brightness.dark ? 0.5 : 0.3;

  Color get themeHint => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.white
      : ColorConsts.iconGrey;

  Color get themeBorderLightGrey => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.greyShade600
      : ColorConsts.lightGrey;
  Color get themeSelectedMenuProfile =>
      Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.black
      : ColorConsts.lightGrey;
  Color get themeSettings => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.lightGrey
      : ColorConsts.black;
  Color get themeSettingsMenu => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.darkDivider
      : ColorConsts.black;
  Color get themeBlueButton => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.greyShade600
      : ColorConsts.lightBlue;

  Color get themeBlueText => Theme.of(this).brightness == Brightness.dark
      ? ColorConsts.lightGrey
      : ColorConsts.textBlue;
}
