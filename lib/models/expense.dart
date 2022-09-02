import 'dart:convert' as conv;

class Expense {
  String id;
  String title;
  String? description;
  int cost;
  DateTime date;
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
        cost: map["cost"],
        date: DateTime.parse(map["date"]).toLocal(),
        categoryId: map["categoryId"] ?? map["category"],
      );

  factory Expense.fromJson(String json) =>
      Expense.fromMap(conv.json.decode(json) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "cost": cost,
        "date": "${date.toIso8601String()}Z",
        "category": categoryId,
      };

  String toJson() => conv.json.encode(toMap());

  static List<Expense> filterByThisWeek(List<Expense> base,
      {bool sort = true}) {
    DateTime now = DateTime.now();

    // Get the date of the first day of the current week
    DateTime firstDayOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1 + 1));

    // Get the date of the last day of the current week
    DateTime lastDayOfWeek = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 7 - now.weekday + 1));

    // Filter the expenses by the current week
    List<Expense> filtered = base.where((expense) {
      return expense.date.isAfter(firstDayOfWeek) &&
          expense.date.isBefore(lastDayOfWeek);
    }).toList();

    // Sort the filtered expenses by date
    if (sort) {
      filtered.sort((a, b) => a.date.compareTo(b.date));
    }

    return filtered;
  }

  static List<Expense> filterByThisMonth(List<Expense> base,
      {bool sort = true}) {
    DateTime now = DateTime.now();

    // Filter the expenses by the current month
    List<Expense> filtered = base.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList();

    // Sort the filtered expenses by date
    if (sort) {
      filtered.sort((a, b) => a.date.compareTo(b.date));
    }

    return filtered;
  }
}
