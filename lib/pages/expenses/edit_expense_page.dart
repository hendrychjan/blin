import 'package:blin/forms/expense_form.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/services/blin_api/blin_expenses_service.dart';
import 'package:blin/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditExpensePage extends StatefulWidget {
  final Expense expense;
  const EditExpensePage({Key? key, required this.expense}) : super(key: key);

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  Future<void> _handleDelete() async {
    // Check if the internet connection is available
    bool connected = await HttpService.checkInternetConnection();

    // If yes, try to delete the expense
    if (connected) {
      // Delete the expense
      await BlinExpensesService.deleteExpense(widget.expense.id);

      // Remove the expense from the local storage
      AppController.to.expenses.remove(widget.expense);

      // Go back to the home page
      Get.back();
    } else {
      throw "No internet.";
    }
  }

  Future<void> _handleUpdate(Map<String, dynamic> form) async {
    // Check if the internet connection is available
    bool connected = await HttpService.checkInternetConnection();

    // If yes, try to update the expense
    if (connected) {
      // Remap the reference fields to their IDs
      form["categoryId"] = form["category"];
      form.remove("category");

      // Update the expense
      Expense updated =
          await BlinExpensesService.updateExpense(form, widget.expense.id);

      // Update the expense in AppController list of expenses
      AppController.to.expenses
          .removeWhere((expense) => expense.id == updated.id);
      AppController.to.expenses.add(updated);

      // Go back to the home page
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
        title: const Text("Edit expense"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: ExpenseForm(
            handleSubmit: _handleUpdate,
            initialState: widget.expense,
            submitButtomText: "Update",
          ),
        ),
      ),
    );
  }
}
