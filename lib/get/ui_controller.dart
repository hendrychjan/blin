import 'package:blin/get/app_controller.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class UiController extends GetxController {
  static UiController get to => Get.find();

  static String colorToHexString(Color color) {
    return '#${color.value.toRadixString(16)}';
  }

  static Color hexStringToColor(String hexString) {
    Color c;
    hexString = hexString.replaceAll("#", "");
    if (hexString.length == 6) {
      c = Color(int.parse("FF$hexString", radix: 16));
    } else {
      c = Color(int.parse(hexString, radix: 16));
    }
    return c;
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
    required String? value,
    Icon? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: hint,
        ),
        value: value ?? items.first["value"],
        items: items.map((item) {
          return DropdownMenuItem(
            value: item["value"],
            child: Text(
              item["text"],
              style: TextStyle(
                  color:
                      UiController.hexStringToColor(item["color"] ?? "194466")),
            ),
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
    DateTimePickerType type = DateTimePickerType.dateTime,
    Icon icon = const Icon(Icons.calendar_today),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DateTimePicker(
        type: type,
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
    Function? onSubmit,
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
        onFieldSubmitted: (value) {
          if (onSubmit != null) onSubmit(value);
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

  static Widget renderMultiSelect({
    required String hint,
    required List<Map> items,
    required Function onChanged,
    required List selectedItems,
    required int selectedLength,
    Icon? icon,
    required BuildContext context,
  }) {
    List<MultiSelectItem> itemsParsed =
        items.map((e) => MultiSelectItem(e["value"], e["text"])).toList();

    String infoText = "Selected: $selectedLength";
    if (selectedLength == 0) infoText = "No items selected";
    if (selectedLength == itemsParsed.length) infoText = "Selected: all";

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async => await showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (ctx) {
                return MultiSelectBottomSheet(
                  title: Text(
                    hint,
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectedColor: Get.theme.primaryColor,
                  cancelText: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  confirmText: const Text("Confirm"),
                  items: itemsParsed,
                  initialValue: selectedItems,
                  onConfirm: (values) => onChanged(values),
                  maxChildSize: 0.8,
                );
              },
            ),
            child: Text(hint),
          ),
          Text(
            infoText,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
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
