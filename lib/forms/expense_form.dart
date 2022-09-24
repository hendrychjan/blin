import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseForm extends StatefulWidget {
  final Function handleSubmit;
  final Expense? initialState;
  final String? submitButtonText;
  const ExpenseForm(
      {Key? key,
      required this.handleSubmit,
      this.initialState,
      this.submitButtonText})
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
  late bool excludedController;

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
      excludedController = widget.initialState!.excluded;
    } else {
      dateController.text = DateTime.now().toString();
      categoryController.text = AppController.to.categories.first.id.toString();
      excludedController = false;
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
                .map((c) => {"text": c.title, "value": c.id, "color": c.color})
                .toList(),
            onChanged: (String selected) {
              setState(() {
                categoryController.text = selected;
              });
            },
            value: categoryController.text,
            icon: const Icon(Icons.category),
          ),
          UiController.renderSwitch(
            hint: "Exclude",
            value: excludedController,
            onChange: (value) {
              setState(() {
                excludedController = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate the form
              if (!formKey.currentState!.validate()) return;

              // Submit the form
              await widget.handleSubmit(
                Expense(
                  id: widget.initialState?.id ?? "0",
                  title: titleController.text,
                  description: descriptionController.text,
                  cost: double.parse(costController.text),
                  date: DateTime.parse(dateController.text),
                  categoryId: categoryController.text,
                  excluded: excludedController,
                ),
              );
            },
            child: Text(widget.submitButtonText ?? "Submit"),
          ),
        ],
      ),
    );
  }
}
