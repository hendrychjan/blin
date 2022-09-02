import 'package:blin/forms/summary_box_settings_form.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SummaryBox extends StatefulWidget {
  const SummaryBox({super.key});

  @override
  State<SummaryBox> createState() => _SummaryBoxState();
}

class _SummaryBoxState extends State<SummaryBox> {
  void _displaySettingsDialog(BuildContext context) async {
    await Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        content: SummaryBoxSettingsForm(
          initialState: {
            'limitValue': AppController.to.limitValue.value,
            'showLimit': AppController.to.showLimit.value,
          },
          handleSubmit: (Map<String, dynamic> values) async {
            AppController.to.limitValue.value = values['limitValue'];
            AppController.to.showLimit.value = values['showLimit'];

            await GetStorage().write("limit_value", values['limitValue']);
            await GetStorage().write("show_limit", values['showLimit']);

            Get.back();
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => _displaySettingsDialog(context),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => Column(
                children: [
                  // Expenses summary
                  Text(
                    "${AppController.to.expensesSummary} Kč",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 33,
                    ),
                  ),
                  // Remaining budget
                  if (AppController.to.showLimit.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Zbývá ${AppController.to.limitValue.value - AppController.to.expensesSummary.value} Kč / ${AppController.to.limitValue.value} Kč",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
