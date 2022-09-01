import 'package:blin/get/app_controller.dart';
import 'package:blin/get/ui_controller.dart';
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(
                  () => Text(
                    "${AppController.to.totalExpenses} Kč",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 33,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => (AppController.to.expenses.isEmpty)
                ? const Text("No expenses")
                : Expanded(
                    child: ListView.builder(
                      itemCount: AppController.to.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = AppController.to.expenses[index];
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
                  ),
          ),
        ],
      ),
    );
  }
}
