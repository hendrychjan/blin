import 'package:blin/models/category.dart';
import 'package:hive/hive.dart';

class HiveCategoryService {
  static final Box<Category> _box = Hive.box<Category>('categories');

  static Future<List<Category>> getCategories() async {
    final categories = _box.values.toList();
    return categories.cast<Category>();
  }

  static Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
  }

  static Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
  }

  static Future<void> deleteCategory(Category category) async {
    await _box.delete(category.id);
  }
}
