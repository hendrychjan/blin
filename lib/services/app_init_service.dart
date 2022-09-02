import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:blin/models/user.dart';
import 'package:blin/services/blin_api/blin_categories_service.dart';
import 'package:blin/services/blin_api/blin_expenses_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInitService {
  static Future<void> init() async {
    // Load and init get_storage
    await _initGetStorage();

    // Download user data
    if (AppController.to.isLoggedIn.value) {
      await downloadUserData();
    }

    // Initialize localization and intl
    await _initLocalizations();

    // Initialize the app info
    await _initAppInfo();
  }

  static Future<void> downloadUserData() async {
    // Download user categories
    List<Category> categories = await BlinCategoriesService.getAllCategories();
    AppController.to.categories.addAll(categories);

    // Download user expenses
    List<Expense> expense = await BlinExpensesService.getAllExpenses();
    AppController.to.expenses.addAll(expense);

    // Calculate the expenses summary
    AppController.to.updateExpensesSummary();
  }

  static Future<void> _initLocalizations() async {
    var locale = AppController.to.appLocale.value.split("_");
    String language = locale[0];
    String country = locale[1];
    await initializeDateFormatting(AppController.to.appLocale.value);
    await Get.updateLocale(Locale(language, country));
  }

  static Future<void> _initAppInfo() async {
    // Get the app info (version and build)
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppController.to.appVersion.value = "v${packageInfo.version}";
  }

  static Future<void> _initGetStorage() async {
    // Initialize the module
    await GetStorage.init();

    // If it is the first time the app is run, set the default values
    await GetStorage()
        .writeIfNull("server_url", "https://blin-space.herokuapp.com");
    await GetStorage().writeIfNull("api_token", "");
    await GetStorage().writeIfNull("app_locale", (await findSystemLocale()));
    await GetStorage().writeIfNull("sum_target", "week");

    // Read user preferences (values from get storage) and set
    // accordingly in app controllers
    AppController.to.serverUrl.value = GetStorage().read("server_url");
    AppController.to.apiToken.value = GetStorage().read("api_token");
    AppController.to.appLocale.value = GetStorage().read("app_locale");
    AppController.to.summaryTarget.value = GetStorage().read("sum_target");

    if (AppController.to.apiToken.value.isNotEmpty) {
      AppController.to.isLoggedIn.value = true;
      AppController.to.user =
          User.fromMap(Jwt.parseJwt(AppController.to.apiToken.value));
    }
  }
}
