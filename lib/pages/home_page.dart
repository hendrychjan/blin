import 'package:blin/components/expenses_list.dart';
import 'package:blin/components/summary_box.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/pages/categories/categories_overview_page.dart';
import 'package:blin/pages/expenses/expenses_overview_page.dart';
import 'package:blin/pages/expenses/new_expense_page.dart';
import 'package:blin/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _handlePopupMenuNavigate(String value) {
    switch (value) {
      case "settings":
        Get.to(() => const SettinsPage());
        return;
      case "categories":
        Get.to(() => const CategoriesOverviewPage());
        return;
      case "expenses":
        Get.to(() => const ExpensesOverviewPage());
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppController.to.updateExpensesSummary();
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text('Home'),
        actions: [
          PopupMenuButton(
            onSelected: _handlePopupMenuNavigate,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "settings",
                child: Row(children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.settings),
                  ),
                  Text("Settings"),
                ]),
              ),
              PopupMenuItem(
                value: "categories",
                child: Row(children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.category),
                  ),
                  Text("Categories"),
                ]),
              ),
              PopupMenuItem(
                value: "expenses",
                child: Row(children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.history),
                  ),
                  Text("All expenses"),
                ]),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: UniqueKey(),
        heroTag: UniqueKey(),
        onPressed: () {
          Get.to(() => const NewExpensePage());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SummaryBox(),
          Obx(
            () {
              // Connect an update hook
              AppController.to.expensesSummary.value;

              final DateTime today = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              );

              // Filter the expenses for the overview list
              List<Expense> expenses = [];
              if (AppController.to.summaryTarget.value == "week") {
                expenses.addAll(
                  Expense.getAll(
                    {"range": "week", "rangeTargetDate": today},
                  ),
                );
              } else if (AppController.to.summaryTarget.value == "month") {
                expenses.addAll(
                  Expense.getAll(
                    {"range": "month", "rangeTargetDate": today},
                  ),
                );
              }

              // If the list is empty, show a message
              if (expenses.isEmpty) {
                return const Text("No expenses");
              }

              // Otherwise, show the list of expenses
              else {
                return Expanded(
                    child: ExpensesList(
                  expenses: expenses,
                ));
              }
            },
          )
        ],
      ),
    );
  }
}
