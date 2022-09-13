import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  // App state
  var appLocale = ''.obs;
  var appVersion = ''.obs;

  // Data state
  var categories = List<Category>.empty(growable: true).obs;
  var expenses = List<Expense>.empty(growable: true).obs;
  var expensesSummary = 0.0.obs;
  var summaryTarget = "".obs;
  var defaultCategoryId = "0".obs;

  // Settings
  var showLimit = false.obs;
  var limitValue = 0.obs;

  void updateExpensesSummary() async {
    List<Expense> expensesFiltered = [];
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (summaryTarget.value == "week") {
      expensesFiltered.addAll(
        Expense.getAll({"range": "week", "rangeTargetDate": today}),
      );
    }

    // Get all expenses that date the current month
    if (summaryTarget.value == "month") {
      expensesFiltered.addAll(
        Expense.getAll({"range": "month", "rangeTargetDate": today}),
      );
    }

    // Sort the expenses from newest to oldest
    expensesFiltered.sort((a, b) => b.date.compareTo(a.date));

    // Save the target expenses
    AppController.to.expenses.clear();
    AppController.to.expenses.addAll(expensesFiltered);

    // Sum the target expenses
    expensesSummary.value =
        expensesFiltered.fold(0, (sum, expense) => sum + expense.cost);
  }
}
