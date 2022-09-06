import 'package:blin/forms/expense_form.dart';
import 'package:blin/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({Key? key}) : super(key: key);

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  Future<void> _handleSubmit(Expense newExpense) async {
    await newExpense.create();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text("New Expense"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: ExpenseForm(handleSubmit: _handleSubmit),
        ),
      ),
    );
  }
}
