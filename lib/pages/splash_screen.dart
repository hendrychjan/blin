import 'package:blin/get/app_controller.dart';
import 'package:blin/pages/home_page.dart';
import 'package:blin/pages/login_page.dart';
import 'package:blin/services/app_init_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _runInit() {
    Future.delayed(
      const Duration(seconds: 2),
      () => AppInitService.init(),
    ).then((v) {
      if (AppController.to.isLoggedIn.value) {
        Get.off(
          () => const HomePage(),
        );
      } else {
        Get.off(
          () => const LoginPage(),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _runInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
