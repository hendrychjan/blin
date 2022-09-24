import 'package:blin/components/expenses_list.dart';
import 'package:blin/forms/expenses_overview_filter_form.dart';
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpensesOverviewPage extends StatefulWidget {
  const ExpensesOverviewPage({Key? key}) : super(key: key);

  @override
  State<ExpensesOverviewPage> createState() => _ExpensesOverviewPageState();
}

class _ExpensesOverviewPageState extends State<ExpensesOverviewPage> {
  late Map _filter = {};
  final List<Expense> _expenses = [];

  void _filterExpenses() {
    List<Expense> filteredExpenses = [];

    if (_filter.isEmpty) {
      filteredExpenses = Expense.getAll();
    } else {
      filteredExpenses = Expense.getAll(_filter);
    }

    setState(() {
      _expenses.clear();
      _expenses.addAll(filteredExpenses);
    });
  }

  void _displayFilterDialog() async {
    await Get.dialog(
      AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        content: ExpensesOverviewFilterForm(
          initialState: _filter,
          handleSubmit: (filter) {
            setState(() {
              _filter = filter;
            });

            Get.back();

            _filterExpenses();
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void initState() {
    super.initState();

    // Set the default filters
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    _filter = {
      "range": "alltime",
      "rangeTargetDate": today,
      "customRangeDateFrom": today,
      "customRangeDateTo": today,
      "categories": AppController.to.categories.map((e) => e.id).toList(),
    };

    Future.delayed(Duration.zero, _displayFilterDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          key: UniqueKey(),
          title: const Text('Expenses'),
          actions: [
            IconButton(
                icon: const Icon(Icons.filter_list_alt),
                onPressed: _displayFilterDialog),
          ],
        ),
        body: Column(
          children: [
            if (_expenses.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No results match the filter'),
                ),
              )
            else
              Column(
                children: [Expanded(child: ExpensesList(expenses: _expenses))],
              ),
          ],
        ));
  }
}
