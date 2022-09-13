import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/pages/expenses/edit_expense_page.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpensesList extends StatefulWidget {
  final List<Expense> expenses;
  const ExpensesList({Key? key, required this.expenses}) : super(key: key);

  @override
  State<ExpensesList> createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  final _dateFormat = DateFormat("EEEE d.M.y", 'cs_CZ');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.expenses.length,
      itemBuilder: (context, index) {
        final expense = widget.expenses[index];
        return GestureDetector(
          onTap: () => Get.to(
            () => EditExpensePage(expense: expense),
          ),
          child: Card(
              key: UniqueKey(),
              child: ListTile(
                title: Text(
                  expense.title,
                ),
                subtitle: Text(
                  _dateFormat.format(expense.date),
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
                tileColor: Colors.grey[50],
                trailing: Text(
                  UiController.formatCurrency(expense.cost + .0),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                textColor: UiController.hexStringToColor(
                  AppController.to.categories
                      .firstWhere((c) => c.id == expense.categoryId)
                      .color,
                ),
              )),
        );
      },
    );
  }
}
