import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/models/user.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  // API connection settings and state
  var serverUrl = ''.obs;
  var apiToken = ''.obs;
  var isLoggedIn = false.obs;
  User? user;

  // App state
  var appLocale = ''.obs;
  var appVersion = ''.obs;

  // Data state
  var categories = List<Category>.empty(growable: true).obs;
  var expenses = List<Expense>.empty(growable: true).obs;
  var expensesSummary = 0.obs;
  var summaryTarget = "".obs;

  // Settings
  var showLimit = false.obs;
  var limitValue = 0.obs;

  void updateExpensesSummary() {
    List<Expense> expensesFiltered = [];

    if (summaryTarget.value == "week") {
      expensesFiltered.addAll(Expense.filterByThisWeek(expenses, sort: false));
    }

    // Get all expenses that date the current month
    if (summaryTarget.value == "month") {
      expensesFiltered.addAll(Expense.filterByThisMonth(expenses, sort: false));
    }

    // Sum the target expenses
    expensesSummary.value =
        expensesFiltered.fold(0, (sum, expense) => sum + expense.cost);
  }
}
