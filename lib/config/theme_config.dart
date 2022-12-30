import 'package:flutter/material.dart';

class ThemeConfig {
  ThemeConfig._();

  static final appTheme = ThemeData(
    primaryColor: kPrimaryColor,
    primarySwatch: kToDark,
    canvasColor: kSecondaryColor,
  );

  static const kPrimaryColor = Color(0xFF1A2E35);
  static const kSecondaryColor = Color(0xFFEAF0F5);
  static const kThirdSecondaryColor = Color(0xFFD9D9D9);
  static const kGravishBlueColor = Color(0xff1564B3);

  static const MaterialColor kToDark = MaterialColor(
    0xFF1A2E35,
    <int, Color>{
      50: Color(0xFF1A2E35),
      100: Color(0xFF1A2E35),
      200: Color(0xFF1A2E35),
      300: Color(0xFF1A2E35),
      500: Color(0xFF1A2E35),
      600: Color(0xFF1A2E35),
      700: Color(0xFF1A2E35),
    },
  );
}
