import 'package:blin/components/summary_box.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/pages/categories/categories_overview_page.dart';
import 'package:blin/pages/expenses/edit_expense_page.dart';
import 'package:blin/pages/expenses/new_expense_page.dart';
import 'package:blin/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dateFormat = DateFormat("EEEE d.M.y", 'cs_CZ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.align_horizontal_left),
            onPressed: () {
              Get.to(() => const CategoriesOverviewPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.to(() => const SettinsPage());
            },
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
              // Filter the expenses for the overview list
              List<Expense> expenses = [];
              if (AppController.to.summaryTarget.value == "week") {
                expenses.addAll(
                    Expense.filterByThisWeek(AppController.to.expenses));
              } else if (AppController.to.summaryTarget.value == "month") {
                expenses.addAll(
                    Expense.filterByThisMonth(AppController.to.expenses));
              }

              // If the list is empty, show a message
              if (AppController.to.expenses.isEmpty) {
                return const Text("No expenses");
              }

              // Otherwise, show the list of expenses
              else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return GestureDetector(
                        onTap: () => Get.to(
                          () => EditExpensePage(expense: expense),
                        ),
                        child: Card(
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
                                AppController
                                    .to.categories
                                    .firstWhere(
                                        (c) => c.id == expense.categoryId)
                                    .color),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
