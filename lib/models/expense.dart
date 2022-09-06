import 'dart:convert' as conv;
import 'package:blin/get/app_controller.dart';
import 'package:blin/services/hive/hive_expense_service.dart';
import 'package:hive/hive.dart';

// hive_generate command: flutter packages pub run build_runner build
part 'expense.g.dart';

@HiveType(typeId: 2)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  double cost;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String categoryId;

  Expense({
    required this.id,
    required this.title,
    this.description,
    required this.cost,
    required this.date,
    required this.categoryId,
  });

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map["id"],
        title: map["title"],
        description: map["description"] ?? "",
        cost: double.parse(map["cost"]),
        date: DateTime.parse(map["date"]).toLocal(),
        categoryId: map["categoryId"],
      );

  factory Expense.fromJson(String json) =>
      Expense.fromMap(conv.json.decode(json) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "cost": cost,
        "date": date.toUtc().toIso8601String(),
        "categoryId": categoryId,
      };

  String toJson() => conv.json.encode(toMap());

  static List<Expense> getAll([Map? filter]) {
    return HiveExpenseService.getExpenses(filter);
  }

  Future<void> create() async {
    // Create a new, unique id
    id = DateTime.now().millisecondsSinceEpoch.toString();

    // DB create
    await HiveExpenseService.addExpense(this);

    // Run the AppController sync hook
    AppController.to.updateExpensesSummary();
  }

  Future<void> update() async {
    // DB update
    await HiveExpenseService.updateExpense(this);

    // Run the AppController sync hook
    AppController.to.updateExpensesSummary();
  }

  Future<void> remove() async {
    // DB delete
    await HiveExpenseService.deleteExpense(this);

    // Run the AppController sync hook
    AppController.to.updateExpensesSummary();
  }

  // static List<Expense> filterByThisWeek(List<Expense> base,
  //     {bool sort = true}) {
  //   DateTime now = DateTime.now();

  //   // Get the date of the first day of the current week
  //   DateTime firstDayOfWeek = DateTime(now.year, now.month, now.day)
  //       .subtract(Duration(days: now.weekday - 1 + 1));

  //   // Get the date of the last day of the current week
  //   DateTime lastDayOfWeek = DateTime(now.year, now.month, now.day)
  //       .add(Duration(days: 7 - now.weekday + 1));

  //   // Filter the expenses by the current week
  //   List<Expense> filtered = base.where((expense) {
  //     return expense.date.isAfter(firstDayOfWeek) &&
  //         expense.date.isBefore(lastDayOfWeek);
  //   }).toList();

  //   // Sort the filtered expenses by date
  //   if (sort) {
  //     filtered.sort((a, b) => a.date.compareTo(b.date));
  //   }

  //   return filtered;
  // }

  // static List<Expense> filterByThisMonth(List<Expense> base,
  //     {bool sort = true}) {
  //   DateTime now = DateTime.now();

  //   // Filter the expenses by the current month
  //   List<Expense> filtered = base.where((expense) {
  //     return expense.date.year == now.year && expense.date.month == now.month;
  //   }).toList();

  //   // Sort the filtered expenses by date
  //   if (sort) {
  //     filtered.sort((a, b) => a.date.compareTo(b.date));
  //   }

  //   return filtered;
  // }
}
