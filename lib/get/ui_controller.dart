import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class UiController extends GetxController {
  static UiController get to => Get.find();

  static String colorToHexString(Color color) {
    return '#${color.value.toRadixString(16)}';
  }

  static Color hexStringToColor(String hexString) {
    return Color(0xFF + int.parse(hexString.substring(1), radix: 16));
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

  static Widget renderColorSelect({
    required String hint,
    required Color controller,
    required Color selected,
    required Function onChanged,
    required Function onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: ElevatedButton(
            onPressed: () async {
              Get.dialog(
                AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: controller,
                      onColorChanged: (color) => onChanged(color),
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        Get.back();
                        onSelected();
                      },
                    ),
                  ],
                ),
              );
            },
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              backgroundColor: MaterialStateProperty.all(selected),
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              ),
            ),
            child: const Text("Theme color"),
          ),
        ),
      ],
    );
  }
}
