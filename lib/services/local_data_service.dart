import 'dart:convert';
import 'dart:io';
import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LocalDataService {
  static Future<void> exportData() async {
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
}
