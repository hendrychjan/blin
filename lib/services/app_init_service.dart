import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
import 'package:blin/models/user.dart';
import 'package:blin/services/blin_api/blin_categories_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AppInitService {
  static Future<void> init() async {
    // Initializa intl formatting
    initializeDateFormatting("cs_CZ");

    // Load and init get_storage
    await _initGetStorage();

    // Download user data
    if (AppController.to.isLoggedIn.value) {
      await downloadUserData();
    }
  }

  static Future<void> downloadUserData() async {
    // Download user categories
    List<Category> categories = await BlinCategoriesService.getAllCategories();
    AppController.to.categories.value = categories;
  }

  static Future<void> _initGetStorage() async {
    // Initialize the module
    await GetStorage.init();

    // If it is the first time the app is run, set the default values
    GetStorage().writeIfNull("server_url", "https://blin-api.nechapu.to");
    GetStorage().writeIfNull("api_token", "");

    // Read user preferences (values from get storage) and set
    // accordingly in app controllers
    AppController.to.serverUrl.value = GetStorage().read("server_url");
    AppController.to.apiToken.value = GetStorage().read("api_token");
    if (AppController.to.apiToken.value.isNotEmpty) {
      AppController.to.isLoggedIn.value = true;
      AppController.to.user =
          User.fromJson(Jwt.parseJwt(AppController.to.apiToken.value));
    }
  }
}
