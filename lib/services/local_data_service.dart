import 'dart:convert';
import 'dart:io';
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LocalDataService {
  static Future<void> backupData() async {
    DateTime timestamp = DateTime.now().toLocal();
    Map<String, dynamic> exportMap = {
      "expenses": [],
      "categories": [],
      "exportDate": timestamp.toIso8601String(),
    };

    // Export all categories
    List<Map> categories =
        (await Category.getAll()).map((e) => e.toMap()).toList();
    (exportMap["categories"] as List).addAll(categories);

    // Export all expenses and populate their categories
    List<Map> expenses = Expense.getAll().map((e) => e.toMap()).toList();
    for (Map expense in expenses) {
      expense["category"] = categories
          .firstWhere((category) => category["id"] == expense["categoryId"]);
    }
    (exportMap["expenses"] as List).addAll(expenses);

    // Encode the export to a temp local file
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String fileName = "blin_backup_${timestamp.millisecondsSinceEpoch}.json";
    String path = join(documentsDir.path, fileName);
    String exportEncoded = jsonEncode(exportMap);

    // Present the backup file to a user and then delete the temp file
    await File(path).writeAsString(exportEncoded);
    await Share.shareFiles([path]);
    await File(path).delete();
  }

  static Future<void> restoreData() async {
    // Load the backup file
    FilePickerResult? res = await FilePicker.platform.pickFiles();
    if (res == null) {
      throw throw "File not provided";
    }

    File backupFile = File(res.files.single.path!);
    Map backupMap = jsonDecode(await backupFile.readAsString());

    // Check the backup format
    if (backupMap["categories"] is! List) {
      throw "Failed to parse: categories missing in backup file";
    }
    if (backupMap["expenses"] is! List) {
      throw "Failed to parse: expenses missing in backup file";
    }

    // Load categories
    List<Category> existingCategories = Category.getAll();
    for (Map<String, dynamic> categoryMap
        in (backupMap["categories"] as List)) {
      try {
        Category category = Category.fromMap(categoryMap);
        if (!category.existsIn(existingCategories)) {
          await category.create(forceId: true);
          existingCategories.add(category);
        }
      } catch (e) {
        throw "Failed to parse: wrong category format";
      }
    }

    // Load expenses
    List<Expense> existingExpenses = Expense.getAll();
    for (Map<String, dynamic> expenseMap in (backupMap["expenses"] as List)) {
      Expense expense = Expense.fromMap(expenseMap);

      if (!expense.categoryExistsIn(existingCategories)) {
        throw "Falied to parse: missing category";
      }

      if (!expense.existsIn(existingExpenses)) {
        await expense.create(forceId: true);
        existingExpenses.add(expense);
      }
    }
  }
}
