import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryBoxSettingsForm extends StatefulWidget {
  final Function handleSubmit;
  final Map initialState;
  const SummaryBoxSettingsForm({
    Key? key,
    required this.handleSubmit,
    required this.initialState,
  }) : super(key: key);

  @override
  State<SummaryBoxSettingsForm> createState() => _SummaryBoxSettingsFormState();
}

class _SummaryBoxSettingsFormState extends State<SummaryBoxSettingsForm> {
  final formKey = GlobalKey<FormState>();
  final _limitValueController = TextEditingController();
  late bool _showLimitController;

  @override
  void initState() {
    super.initState();
    _limitValueController.text = widget.initialState['limitValue'].toString();
    _showLimitController = widget.initialState['showLimit'];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          UiController.renderTextInput(
            hint: "Spendings limit",
            controller: _limitValueController,
            validationRules: ["required"],
          ),
          UiController.renderSwitch(
            hint: "Display spendings limit",
            value: _showLimitController,
            onChange: (value) {
              setState(() {
                _showLimitController = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: Get.back,
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Validate the form
                  if (!formKey.currentState!.validate()) return;

                  await widget.handleSubmit(
                    {
                      'limitValue': int.parse(_limitValueController.text),
                      'showLimit': _showLimitController,
                    },
                  );
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
