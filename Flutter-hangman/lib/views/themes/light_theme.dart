import 'package:flutter/material.dart';

/*
Edit the Theme of the app here
*/

class LightTheme {
  static ThemeData themeData = ThemeData(
    colorScheme: ColorScheme(
          primary: Color(0xFF8950E6),
          primaryVariant: Color(0xFF4B4453),
          secondary: Color(0xFF00A1FF),
          secondaryVariant: Color(0xFF3896B6),
          surface: Color(0xFFFFFFFF),
          background: Color(0xFFFFFFFF),
          error: Color(0xFFA83232),
          onPrimary: Color(0xFFFFFFFF),
          onSecondary: Color(0xFFFFFFFF),
          onSurface: Color(0xFFFFFFFF),
          onBackground: Color(0xFFFFFFFF),
          onError: Color(0xFFFFFFFF), 
          brightness: Brightness.light,
        ),
    textTheme: TextTheme(
        body1: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        body2: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 16,
          fontWeight: FontWeight.w700
        ),
        title: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 24,
          fontWeight: FontWeight.w600
        ),
        button: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.w500
        ),
        caption: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic
        ),
        display1: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 32,
          fontWeight: FontWeight.w300
        ),
        display2: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 36,
          fontWeight: FontWeight.w300
        ),
        display3: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 38,
          fontWeight: FontWeight.w300
        ),
        display4: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 40,
          fontWeight: FontWeight.w300
        ),
        overline: TextStyle(
          color: Color(0xFF2D2D2D),
          fontSize: 10,
          fontWeight: FontWeight.w400
        ),
      ),
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    buttonColor: Color(0xFF0096B0)
  );
}
