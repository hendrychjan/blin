import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpensesOverviewFilterForm extends StatefulWidget {
  final Function handleSubmit;
  final Map initialState;
  const ExpensesOverviewFilterForm({
    Key? key,
    required this.handleSubmit,
    required this.initialState,
  }) : super(key: key);

  @override
  State<ExpensesOverviewFilterForm> createState() =>
      _ExpensesOverviewFilterFormState();
}

class _ExpensesOverviewFilterFormState
    extends State<ExpensesOverviewFilterForm> {
  final formKey = GlobalKey<FormState>();
  final _rangeController = TextEditingController();
  final _customRangeDateFrom = TextEditingController();
  final _customRangeDateTo = TextEditingController();
  final _rangeTargetDate = TextEditingController();
  final _excludedController = TextEditingController();
  List _categoriesController = [];

  final _excludedOptions = [
    {"text": "All", "value": "all"},
    {"text": "Excluded", "value": "is"},
    {"text": "Not excluded", "value": "is not"}
  ];

  final _timeRangeOptions = [
    {"text": "All time", "value": "alltime"},
    {"text": "Year", "value": "year"},
    {"text": "Month", "value": "month"},
    {"text": "Week", "value": "week"},
    {"text": "Custom", "value": "custom"},
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the fields from initial state
    _rangeController.text = widget.initialState["range"];
    _customRangeDateFrom.text =
        widget.initialState["customRangeDateFrom"].toString();
    _customRangeDateTo.text =
        widget.initialState["customRangeDateTo"].toString();
    _rangeTargetDate.text = widget.initialState["rangeTargetDate"].toString();
    _categoriesController.addAll(widget.initialState["categories"]);
    _excludedController.text = "all";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UiController.renderMultiSelect(
            hint: "Categories",
            selectedItems: _categoriesController,
            items: AppController.to.categories
                .map((e) => {
                      "text": e.title,
                      "value": e.id,
                    })
                .toList(),
            onChanged: (List<dynamic> values) {
              setState(() {
                _categoriesController = values;
              });
            },
            context: context,
            selectedLength: _categoriesController.length,
          ),
          UiController.renderSelect(
            hint: "Time range",
            items: _timeRangeOptions,
            value: _rangeController.text,
            onChanged: (String selected) => setState(
              () {
                _rangeController.text = selected;
              },
            ),
          ),
          if (_rangeController.text == "custom")
            UiController.renderDateTimePicker(
              hint: "Date from",
              contoller: _customRangeDateFrom,
              validationRules: ["required"],
              type: DateTimePickerType.date,
            ),
          if (_rangeController.text == "custom")
            UiController.renderDateTimePicker(
              hint: "Date to",
              contoller: _customRangeDateTo,
              validationRules: ["required"],
              type: DateTimePickerType.date,
            ),
          if (_rangeController.text != "custom" &&
              _rangeController.text != "alltime")
            UiController.renderDateTimePicker(
              hint: "Target date",
              contoller: _rangeTargetDate,
              validationRules: ["required"],
              type: DateTimePickerType.date,
            ),
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
                      "excluded": _excludedController.text,
                      "range": _rangeController.text,
                      "customRangeDateFrom":
                          DateTime.parse(_customRangeDateFrom.text),
                      "customRangeDateTo":
                          DateTime.parse(_customRangeDateTo.text),
                      "rangeTargetDate": DateTime.parse(_rangeTargetDate.text),
                      "categories": _categoriesController,
                    },
                  );
                },
                child: const Text("Ok"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
