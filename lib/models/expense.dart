import 'dart:convert' as conv;
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
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

  @HiveField(6)
  bool excluded;

  Expense({
    required this.id,
    required this.title,
    this.description,
    required this.cost,
    required this.date,
    required this.categoryId,
    required this.excluded,
  });

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map["id"].toString(),
        title: map["title"],
        description: map["description"] ?? "",
        cost: double.parse(map["cost"].toString()),
        date: DateTime.parse(map["date"]).toLocal(),
        categoryId: map["categoryId"],
        excluded: map["excluded"].toString() == "true",
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
        "excluded": excluded,
      };

  String toJson() => conv.json.encode(toMap());

  static List<Expense> getAll([Map? filter]) {
    return HiveExpenseService.getExpenses(filter);
  }

  Future<void> create({forceId = false}) async {
    // Create a new, unique id
    if (!forceId) id = DateTime.now().millisecondsSinceEpoch.toString();

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

  bool existsIn(List<Expense> target) {
    return target.where((e) => e.id == id).isNotEmpty;
  }

  bool categoryExistsIn(List<Category> categories) {
    return categories.where((c) => c.id == categoryId).isNotEmpty;
  }
}
