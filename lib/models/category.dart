class Category {
  String? id;
  String name;
  String? description;
  String color;

  Category({
    this.id,
    required this.name,
    this.description,
    required this.color,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        description = json["description"],
        color = json["color"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "color": color,
      };
}
