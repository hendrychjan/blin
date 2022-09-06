import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
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
    AppController.to.categories.addAll((await Category.getAll()));
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
    await GetStorage().writeIfNull("app_locale", (await findSystemLocale()));
    await GetStorage().writeIfNull("sum_target", "week");
    await GetStorage().writeIfNull("show_limit", false);
    await GetStorage().writeIfNull("limit_value", 0);

    // Read user preferences (values from get storage) and set
    // accordingly in app controllers
    AppController.to.appLocale.value = GetStorage().read("app_locale");
    AppController.to.summaryTarget.value = GetStorage().read("sum_target");
    AppController.to.showLimit.value = GetStorage().read("show_limit");
    AppController.to.limitValue.value = GetStorage().read("limit_value");
  }
}
