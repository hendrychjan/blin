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
}
