import 'dart:convert' as conv;
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/services/hive/hive_category_service.dart';
import 'package:hive/hive.dart';

// hive_generate command: flutter packages pub run build_runner build
part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
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

  static List<Category> getAll() {
    return HiveCategoryService.getCategories();
  }

  Future<void> create({forceId = false}) async {
    // Create a new, unique id
    if (!forceId) id = DateTime.now().millisecondsSinceEpoch.toString();

    // DB create
    await HiveCategoryService.addCategory(this);

    // AppController update
    AppController.to.categories.add(this);
  }

  Future<void> update() async {
    // DB update
    await HiveCategoryService.updateCategory(this);

    // AppController update
    int index = AppController.to.categories.indexWhere((c) => c.id == id);
    AppController.to.categories[index] = this;
  }

  Future<void> remove() async {
    // Check - the default category cannot be removed
    if (id == "0") return;

    // Check - the category cannot be removed if it has expenses
    List<Expense> expenses = Expense.getAll({
      "categories": [id]
    });
    if (expenses.isNotEmpty) throw "Cannot delete a category with expenses";

    // DB remove
    await HiveCategoryService.deleteCategory(this);

    // AppController update
    AppController.to.categories.removeWhere((c) => c.id == id);
  }

  static void ensureDefault() async {
    if (AppController.to.categories.isEmpty) {
      Category category = Category(
        id: "0",
        title: "Default",
        description: "Default category",
        color: "#FF194466",
      );

      // DB create
      await HiveCategoryService.addCategory(category);

      // Add to AppController
      AppController.to.categories.add(category);
    }
  }

  bool existsIn(List<Category> target) {
    return target.where((c) => c.id == id).isNotEmpty;
  }
}
