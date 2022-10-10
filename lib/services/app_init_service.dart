import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInitService {
  static Future<void> init() async {
    // Load and init get_storage
    await _initGetStorage();

    // Init hive
    await _initHive();

    // Load hive data
    await _loadHiveData();

    // Initialize localization and intl
    await _initLocalizations();

    // Initialize the app info
    await _initAppInfo();
  }

  static Future<void> _initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(ExpenseAdapter());

    await Hive.openBox<Category>('categories');
    await Hive.openBox<Expense>('expenses');
  }

  static Future<void> _loadHiveData() async {
    // Load data to app controller

    // Categories
    AppController.to.categories.addAll(Category.getAll());

    // Expenses
    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    List<Expense> expenses = [];
    if (AppController.to.summaryTarget.value == "week") {
      expenses.addAll(
        Expense.getAll(
          {"range": "week", "rangeTargetDate": today},
        ),
      );
    } else if (AppController.to.summaryTarget.value == "month") {
      expenses.addAll(
        Expense.getAll(
          {"range": "month", "rangeTargetDate": today},
        ),
      );
    }
    AppController.to.expenses.addAll(expenses);

    // Create the default values
    Category.ensureDefault();
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

    String defaultLocale = await findSystemLocale();
    NumberFormat defaultCurrency =
        NumberFormat.simpleCurrency(locale: defaultLocale);

    // If it is the first time the app is run, set the default values
    await GetStorage().writeIfNull("app_locale", defaultLocale);
    await GetStorage().writeIfNull("sum_target", "week");
    await GetStorage().writeIfNull("show_limit", false);
    await GetStorage().writeIfNull("show_decimals", false);
    await GetStorage().writeIfNull("limit_value", 0);
    await GetStorage().writeIfNull("show_excluded", "all");
    await GetStorage().writeIfNull("currency", defaultCurrency.currencyName);

    // Read user preferences (values from get storage) and set
    // accordingly in app controllers
    AppController.to.appLocale.value = GetStorage().read("app_locale");
    AppController.to.summaryTarget.value = GetStorage().read("sum_target");
    AppController.to.showLimit.value = GetStorage().read("show_limit");
    AppController.to.showDecimals.value = GetStorage().read("show_decimals");
    AppController.to.limitValue.value = GetStorage().read("limit_value");
    AppController.to.showExcluded.value = GetStorage().read("show_excluded");
    AppController.to.currency.value = GetStorage().read("currency");
  }
}
