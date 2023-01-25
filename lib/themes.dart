import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const mainBg = Color(0xffe9ecef);
  static const iconLightGrey = Color(0xffb1b3c1);
  static const iconDarkRed = Color(0xffae2012);
  static const cardRedLight = Color(0xffEF4444);
  static const cardYellowLight = Color(0xffEAB308);
  static const cardGreenLight = Color(0xff22C55E);
  static const cardPurpleLight = Color(0xffA855F7);
  static const cardBlueDark = Color(0xff3B82F6);
  static const btnBlue = Color(0xff3B81F6);
  static const textDark = Color(0xff53585a);
  static const mainColor = Color(0xff374151);
  static const reportLightRed = Color(0xffFEF1F2);
  static const reportDarkRed = Color(0xffBC2624);

  static const secondary = Color(0xff3b76f6);
  static const accent = Color(0xffd67558);

  static const textLight = Color(0xfff5f5f5);
  static const textFaded = Color(0xff9899a5);
  static const iconLight = Color(0xffb1b4c0);
  static const iconDark = Color(0xffb1b3c1);
  static const textHighLight = secondary;
  static const cardLight = Color(0xfff9fafe);
  static const cardDark = Color(0xff303334);
}

abstract class _LightColors {
  static const background = Colors.white;
  static const card = AppColors.cardLight;
}

abstract class _DarkColors {
  static const background = Color(0xff1b1e1f);
  static const card = AppColors.cardDark;
}

abstract class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  //Light Theme and its settings
  static ThemeData light() => ThemeData(
      brightness: Brightness.light,
      accentColor: accentColor,
      visualDensity: visualDensity,
      textTheme:
          GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textDark),
      backgroundColor: _LightColors.background,
      scaffoldBackgroundColor: _LightColors.background,
      cardColor: _LightColors.card,
      primaryTextTheme: const TextTheme(
        headline6: TextStyle(color: AppColors.textDark),
      ),
      iconTheme: const IconThemeData(color: AppColors.iconDark));

  //Dark Theme and its settings
  static ThemeData dark() => ThemeData(
      brightness: Brightness.dark,
      accentColor: accentColor,
      visualDensity: visualDensity,
      textTheme:
          GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textLight),
      backgroundColor: _DarkColors.background,
      scaffoldBackgroundColor: _DarkColors.background,
      cardColor: _DarkColors.card,
      primaryTextTheme: const TextTheme(
        headline6: TextStyle(color: AppColors.textLight),
      ),
      iconTheme: const IconThemeData(color: AppColors.iconLight));
}
