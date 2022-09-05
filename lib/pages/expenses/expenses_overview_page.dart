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

    // Filter by category
    filteredExpenses = AppController.to.expenses
        .where((e) => (_filter["categories"] as List).contains(e.categoryId))
        .toList();

    // Filter by date
    if (_filter["range"] == "alltime") {
      // Do nothing
    } else if (_filter["range"] == "year") {
      filteredExpenses = filteredExpenses
          .where((e) => e.date.year == _filter["rangeTargetDate"].year)
          .toList();
    } else if (_filter["range"] == "month") {
      filteredExpenses = filteredExpenses
          .where((e) =>
              e.date.year == _filter["rangeTargetDate"].year &&
              e.date.month == _filter["rangeTargetDate"].month)
          .toList();
    } else if (_filter["range"] == "week") {
      DateTime base = _filter["rangeTargetDate"];

      // Get the date of the first day of the current week
      DateTime firstDayOfWeek = DateTime(base.year, base.month, base.day)
          .subtract(Duration(days: base.weekday - 1 + 1));

      // Get the date of the last day of the current week
      DateTime lastDayOfWeek = DateTime(base.year, base.month, base.day)
          .add(Duration(days: 7 - base.weekday + 1));

      // Filter the expenses by the current week
      filteredExpenses = filteredExpenses.where((expense) {
        return expense.date.isAfter(firstDayOfWeek) &&
            expense.date.isBefore(lastDayOfWeek);
      }).toList();
    } else if (_filter["range"] == "custom") {
      filteredExpenses = filteredExpenses
          .where((e) =>
              e.date.isAfter(_filter["customRangeDateFrom"]) &&
              e.date.isBefore(_filter["customRangeDateTo"]))
          .toList();
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
              Expanded(child: ExpensesList(expenses: _expenses)),
          ],
        ));
  }
}