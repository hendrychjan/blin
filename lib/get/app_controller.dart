import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/models/user.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  var serverUrl = ''.obs;
  var apiToken = ''.obs;
  var isLoggedIn = false.obs;
  var appLocale = ''.obs;
  var categories = List<Category>.empty(growable: true).obs;
  var expenses = List<Expense>.empty(growable: true).obs;
  var totalExpenses = 400.obs;
  var appVersion = ''.obs;
  User? user;
}
