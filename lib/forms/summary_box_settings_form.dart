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
  final _excludedController = TextEditingController();
  late bool _showLimitController;
  late bool _showDecimalsController;

  final _excludedOptions = [
    {"text": "All", "value": "all"},
    {"text": "Excluded", "value": "is"},
    {"text": "Not excluded", "value": "is not"}
  ];

  @override
  void initState() {
    super.initState();
    _excludedController.text = widget.initialState['excluded'];
    _limitValueController.text = widget.initialState['limitValue'].toString();
    _showLimitController = widget.initialState['showLimit'];
    _showDecimalsController = widget.initialState['showDecimals'];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          UiController.renderSelect(
            hint: "Excluded",
            items: _excludedOptions,
            value: _excludedController.text,
            onChanged: (String selected) => setState(
              () {
                _excludedController.text = selected;
              },
            ),
          ),
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
          UiController.renderSwitch(
            hint: "Display decimals",
            value: _showDecimalsController,
            onChange: (value) {
              setState(() {
                _showDecimalsController = value;
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
                      'excluded': _excludedController.text,
                      'limitValue': int.parse(_limitValueController.text),
                      'showLimit': _showLimitController,
                      'showDecimals': _showDecimalsController,
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
