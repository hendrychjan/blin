import 'package:blin/forms/expense_form.dart';
import 'package:blin/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditExpensePage extends StatefulWidget {
  final Expense expense;
  const EditExpensePage({Key? key, required this.expense}) : super(key: key);

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  Future<void> _handleRemove() async {
    await widget.expense.remove();
    Get.back();
  }

  Future<void> _handleUpdate(Expense updatedExpense) async {
    await updatedExpense.update();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text("Edit expense"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleRemove,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: ExpenseForm(
            handleSubmit: _handleUpdate,
            initialState: widget.expense,
            submitButtonText: "Update",
          ),
        ),
      ),
    );
  }
}
