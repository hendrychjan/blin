import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppearanceSettingsSection extends StatefulWidget {
  const AppearanceSettingsSection({super.key});

  @override
  State<AppearanceSettingsSection> createState() =>
      _AppearanceSettingsSectionState();
}

class _AppearanceSettingsSectionState extends State<AppearanceSettingsSection> {
  final formKey = GlobalKey<FormState>();
  final _currencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currencyController.text = AppController.to.currency.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Appearance",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
            UiController.renderTextInput(
                hint: "Currency",
                controller: _currencyController,
                validationRules: ["required"],
                onSubmit: (String value) async {
                  _currencyController.text = value;
                  AppController.to.currency.value = value;
                  await GetStorage().write("currency", value);
                }),
          ],
        ),
      ),
    );
  }
}
