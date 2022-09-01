import 'dart:convert' as conv;

class Category {
  String id;
  String title;
  String? description;
  String color;

  Category({
    required this.id,
    required this.title,
    this.description,
    required this.color,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      color: map["color"],
    );
  }

  factory Category.fromJson(String json) =>
      Category.fromMap(conv.json.decode(json) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "color": color,
      };

  String toJson() => conv.json.encode(toMap());
}
