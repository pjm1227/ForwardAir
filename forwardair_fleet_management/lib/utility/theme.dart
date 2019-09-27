import 'package:flutter/material.dart';

import 'colors.dart';

/*This class is used to customization for app theme.
* */
final ThemeData customThemeData = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: MaterialColor(CustomColors.blue[900].value, CustomColors.blue),
  primaryColor: CustomColors.blue[900],
  primaryColorBrightness: Brightness.light,
  accentColor: CustomColors.blue[600],
  accentColorBrightness: Brightness.light,
  primaryColorDark: Colors.red,
);

//Here We need to pass the colors as per app theme.
class CustomColors {
  CustomColors._(); // this basically makes it so you can instantiate this class
  static const Map<int, Color> blue = const <int, Color>{
    50: const Color(0xFFe7e9ea),
    100: const Color(0xFFcfd4d6),
    200: const Color(0xFFB7BFC2),
    300: const Color(0xFF9FAAAD),
    400: const Color(0xFF879599),
    500: const Color(0xFF6F7F85),
    600: const Color(0xFF576A70),
    700: const Color(0xFF3E555C),
    800: const Color(0xFF264048),
    900: const Color(0xFF0F2B34),
  };
}

ThemeData basicTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      //textTheme: baseTextTheme(base.textTheme),
//     accentColor: CustomColors.blue[600],
//      primaryColor: CustomColors.blue[900],
//      primaryColorDark: Colors.red,
      appBarTheme: AppBarTheme(
          color: CustomColors.blue[900],
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(title: TextStyle(color: AppColors.colorWhite))));
}
