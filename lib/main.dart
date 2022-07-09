import 'package:blin/get/app_controller.dart';
import 'package:blin/pages/splash_screen.dart';
import 'package:blin/theme/blin_ui_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(AppController());

  runApp(GetMaterialApp(
    title: 'Blin',
    theme: BlinUITheme.lightTheme,
    locale: const Locale('cs', 'CZ'),
    home: const SplashScreen(),
  ));
}
