import 'package:blin/models/expense.dart';
import 'package:hive/hive.dart';

class HiveExpenseService {
  static final Box<Expense> _box = Hive.box<Expense>('expenses');

  static List<Expense> getExpenses([Map? filter]) {
    List<Expense> expenses = _box.values.where((expense) {
      // No filters
      if (filter == null) return true;

      // Filter by category
      if (filter.containsKey("categories")) {
        if (!(filter["categories"] as List).contains(expense.categoryId)) {
          return false;
        }
      }

      // Filter by "excluded"
      if (filter.containsKey("excluded")) {
        if (filter["excluded"] == "all") {
          // Do nothing
        } else if (filter["excluded"] == "is" && !expense.excluded) {
          return false;
        } else if (filter["excluded"] == "is not" && expense.excluded) {
          return false;
        }
      }

      // Filter by date
      if (filter.containsKey("range")) {
        if (filter["range"] == "alltime") {
          // Do nothing
        } else if (filter["range"] == "year") {
          if (expense.date.year != filter["rangeTargetDate"].year) {
            return false;
          }
        } else if (filter["range"] == "month") {
          if (expense.date.year != filter["rangeTargetDate"].year ||
              expense.date.month != filter["rangeTargetDate"].month) {
            return false;
          }
        } else if (filter["range"] == "week") {
          DateTime base = filter["rangeTargetDate"] as DateTime;

          // Get the date of the first day of the current week
          DateTime firstDayOfWeek = DateTime(base.year, base.month, base.day)
              .subtract(Duration(days: base.weekday - 1));

          // Get the date of the last day of the current week
          DateTime lastDayOfWeek = DateTime(base.year, base.month, base.day)
              .add(Duration(days: 7 - base.weekday));

          // Filter the expenses by the current week
          if (expense.date.isBefore(firstDayOfWeek) ||
              expense.date.isAfter(lastDayOfWeek)) {
            return false;
          }
        } else if (filter["range"] == "custom") {
          if (expense.date.isBefore((filter["customRangeDateFrom"] as DateTime)
                  .add(const Duration(days: 1))) ||
              expense.date.isAfter((filter["customRangeDateTo"] as DateTime)
                  .subtract(const Duration(days: 1)))) {
            return false;
          }
        }
      }

      return true;
    }).toList();

    return expenses;
  }

  static Future<void> addExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  static Future<void> updateExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  static Future<void> deleteExpense(Expense expense) async {
    await _box.delete(expense.id);
  }
}
