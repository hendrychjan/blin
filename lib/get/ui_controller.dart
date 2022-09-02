import 'package:blin/get/app_controller.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UiController extends GetxController {
  static UiController get to => Get.find();

  static String colorToHexString(Color color) {
    return '#${color.value.toRadixString(16)}';
  }

  static Color hexStringToColor(String hexString) {
    return Color(0xFF + int.parse(hexString.substring(1), radix: 16));
  }

  static String formatCurrency(double value) {
    String localeString = AppController.to.appLocale.string;

    switch (localeString) {
      case "cs_CZ":
        return "${value.round()} Kč";
      default:
        return NumberFormat.currency(locale: AppController.to.appLocale.value)
            .format(value);
    }
  }

  static Widget renderSwitch({
    required bool value,
    required Function onChange,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(hint),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: (v) => onChange(v),
            activeColor: Get.theme.primaryColor,
          ),
        ],
      ),
    );
  }

  static Widget renderSelect({
    required String hint,
    required List<Map> items,
    required Function onChanged,
    Icon? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: hint,
        ),
        value: items.first["value"],
        items: items.map((item) {
          return DropdownMenuItem(
            value: item["value"],
            child: Text(item["text"]),
          );
        }).toList(),
        onChanged: (v) => onChanged(v),
      ),
    );
  }

  static Widget renderDateTimePicker({
    required String hint,
    required TextEditingController contoller,
    required List<String> validationRules,
    Icon icon = const Icon(Icons.calendar_today),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DateTimePicker(
        type: DateTimePickerType.dateTime,
        controller: contoller,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        fieldLabelText: hint,
        initialDate: DateTime.now(),
        initialTime: TimeOfDay.now(),
        validator: (value) {
          return _handleValidate(value.toString(), validationRules);
        },
        locale: Get.locale,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: hint,
        ),
      ),
    );
  }

  static Widget renderTextInput({
    required String hint,
    required TextEditingController controller,
    required List<String> validationRules,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Icon? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: icon,
        ),
        obscureText: obscureText,
        validator: (value) {
          return _handleValidate(value.toString(), validationRules);
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
    Icon? icon,
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

  static String? _handleValidate(String? value, List<String> validationRules) {
    if (validationRules.contains("required")) {
      if (value == null || value.isEmpty) {
        return "This field is required";
      }
    }

    return null;
  }
}
