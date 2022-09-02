import 'package:blin/forms/expense_form.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/services/blin_api/blin_expenses_service.dart';
import 'package:blin/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({Key? key}) : super(key: key);

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  Future<void> _handleSubmit(Map formValues) async {
    // Check if the internet connection is available
    bool connected = await HttpService.checkInternetConnection();

    // If yes, try to create the expense
    if (connected) {
      // Create the expense
      Expense created = await BlinExpensesService.createNewExpense(formValues);

      // Save the expense to local storage
      AppController.to.expenses.add(created);

      // Update the expenses summary
      AppController.to.updateExpensesSummary();

      Get.back();
    } else {
      throw "No internet.";
    }
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
