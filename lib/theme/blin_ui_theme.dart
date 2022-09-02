import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlinUITheme {
  static final ThemeData lightTheme = buildLightTheme();

  static ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();

    const primaryColor = Color(0xFF194466);
    const secondaryColor = Color.fromARGB(12, 25, 69, 102);

    return base.copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(accentColor: primaryColor),
      splashColor: primaryColor,

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            // elevation: 0,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 17,
            )),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          elevation: 0,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            color: primaryColor,
            fontSize: 17,
          ),
        ),
      ),

      // Input
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        border: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: primaryColor,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        fillColor: secondaryColor,
        filled: true,
        hintStyle: const TextStyle(
          color: primaryColor,
        ),
        labelStyle: const TextStyle(
          color: primaryColor,
        ),
        iconColor: primaryColor,
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actionsIconTheme: IconThemeData(
          color: primaryColor,
        ),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
      ),

      // Action button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // Card
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      ),

      // Scaffold
      scaffoldBackgroundColor: Colors.white,

      // Text Selection
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionHandleColor: primaryColor,
        selectionColor: Color.fromARGB(66, 25, 69, 102),
      ),

      // Circular Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }
}
