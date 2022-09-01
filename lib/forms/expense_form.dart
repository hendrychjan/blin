import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseForm extends StatefulWidget {
  final Function handleSubmit;
  final Expense? initialState;
  final String? submitButtomText;
  const ExpenseForm(
      {Key? key,
      required this.handleSubmit,
      this.initialState,
      this.submitButtomText})
      : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final costController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  String _error = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize the fields if initial state exists
    if (widget.initialState != null) {
      titleController.text = widget.initialState!.title;
      descriptionController.text = widget.initialState!.description ?? "";
      costController.text = widget.initialState!.cost.toString();
      dateController.text = widget.initialState!.date.toString();
      categoryController.text = widget.initialState!.categoryId;
    } else {
      dateController.text = DateTime.now().toString();
      categoryController.text = AppController.to.categories.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UiController.renderTextInput(
            hint: "Title",
            controller: titleController,
            validationRules: ["required"],
            icon: const Icon(Icons.edit),
          ),
          UiController.renderTextInput(
            hint: "Description",
            controller: descriptionController,
            validationRules: [""],
            icon: const Icon(Icons.description),
          ),
          UiController.renderTextInput(
            hint: "Cost",
            controller: costController,
            validationRules: ["required"],
            keyboardType: TextInputType.number,
            icon: const Icon(Icons.attach_money),
          ),
          UiController.renderDateTimePicker(
            hint: "Date",
            contoller: dateController,
            validationRules: ["required"],
          ),
          UiController.renderSelect(
            hint: "Category",
            items: AppController.to.categories
                .map((c) => {"text": c.title, "value": c.id})
                .toList(),
            onChanged: (String selected) {
              setState(() {
                categoryController.text = selected;
              });
            },
            icon: const Icon(Icons.category),
          ),
          (!_isLoading)
              ? ElevatedButton(
                  onPressed: () async {
                    // Validate the form
                    if (!formKey.currentState!.validate()) return;

                    setState(() {
                      _isLoading = true;
                    });

                    await widget.handleSubmit({
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "cost": int.parse(costController.text),
                      "date": DateTime.parse(dateController.text)
                          .toUtc()
                          .toIso8601String(),
                      "category": categoryController.text,
                    });

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: Text(widget.submitButtomText ?? "Submit"),
                )
              : const CircularProgressIndicator(),
          Text(
            _error,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
