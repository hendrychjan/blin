import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

    // Initialize the fields if initial state exists
    if (widget.initialState != null) {
      titleController.text = widget.initialState!.title;
      descriptionController.text = widget.initialState!.description ?? "";
      costController.text = widget.initialState!.cost.toString();
      dateController.text = widget.initialState!.date.toString();
      categoryController.text = widget.initialState!.categoryId.toString();
    } else {
      dateController.text = DateTime.now().toString();
      categoryController.text = AppController.to.categories.first.id.toString();
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
            onChanged: (Category selected) {
              setState(() {
                categoryController.text = selected.id;
              });
            },
            icon: const Icon(Icons.category),
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate the form
              if (!formKey.currentState!.validate()) return;

              // Submit the form
              await widget.handleSubmit(Expense(
                id: widget.initialState?.id ?? "0",
                title: titleController.text,
                description: descriptionController.text,
                cost: double.parse(costController.text),
                date: DateTime.parse(dateController.text),
                categoryId: categoryController.text,
              ));
            },
            child: Text(widget.submitButtomText ?? "Submit"),
          ),
        ],
      ),
    );
  }
}
