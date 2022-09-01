import 'package:blin/get/app_controller.dart';
import 'package:blin/pages/splash_screen.dart';
import 'package:blin/theme/blin_ui_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Get.put(AppController());

  runApp(GetMaterialApp(
    title: 'Blin',
    theme: BlinUITheme.lightTheme,
    home: const SplashScreen(),
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const [Locale('en'), Locale('cs', 'CZ')],
  ));
}
