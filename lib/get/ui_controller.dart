import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UiController extends GetxController {
  static UiController get to => Get.find();

  static void fixAndroidOverlayColor() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            // statusBarBrightness: Brightness.dark,
            // statusBarIconBrightness: Brightness.dark,
            // systemNavigationBarColor: Color(0xFFf5f5f5), // navigation bar color
            // statusBarColor:
            //     Color(0xFFf5f5f5), // status bar color// status bar color
            ),
      );
    }
  }

  static Widget renderTextInput({
    required String hint,
    required TextEditingController controller,
    required List<String> validationRules,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          // hintText: hint,
          labelText: hint,
        ),
        obscureText: obscureText,
        validator: (value) {
          if (validationRules.contains("required")) {
            if (value == null || value.isEmpty) {
              return "This field is required";
            }
          }

          return null;
        },
      ),
    );
  }
}
