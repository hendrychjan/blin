import 'package:blin/forms/summary_box_settings_form.dart';
import 'package:blin/get/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SummaryBox extends StatefulWidget {
  const SummaryBox({super.key});

  @override
  State<SummaryBox> createState() => _SummaryBoxState();
}

class _SummaryBoxState extends State<SummaryBox> {
  void _displaySettingsDialog() async {
    await Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        content: SummaryBoxSettingsForm(
          initialState: {
            'excluded': AppController.to.showExcluded.value,
            'limitValue': AppController.to.limitValue.value,
            'showLimit': AppController.to.showLimit.value,
            'showDecimals': AppController.to.showDecimals.value,
          },
          handleSubmit: (Map<String, dynamic> values) async {
            AppController.to.showExcluded.value = values['excluded'];
            AppController.to.limitValue.value = values['limitValue'];
            AppController.to.showLimit.value = values['showLimit'];
            AppController.to.showDecimals.value = values['showDecimals'];

            await GetStorage().write("show_excluded", values['excluded']);
            await GetStorage().write("limit_value", values['limitValue']);
            await GetStorage().write("show_limit", values['showLimit']);
            await GetStorage().write("show_decimals", values['showDecimals']);

            AppController.to.updateExpensesSummary();

            Get.back();
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  String _formatNumber(double value) {
    if (!AppController.to.showDecimals.value) {
      return value.round().toString();
    } else {
      return value.toString();
    }
  }

  String _getLimitText() {
    String text = "";

    text += "Remaining: ";
    text += _formatNumber(
      AppController.to.limitValue.value -
          AppController.to.expensesSummary.value,
    );
    text += " / ";
    text += _formatNumber(AppController.to.limitValue.value + .0);
    text += " ${AppController.to.currency.value}";

    return text;
  }

  String _getSummaryText() {
    String text = "";

    text += _formatNumber(AppController.to.expensesSummary.value);
    text += " ${AppController.to.currency.value}";

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: _displaySettingsDialog,
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
                    _getSummaryText(),
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
                        _getLimitText(),
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
