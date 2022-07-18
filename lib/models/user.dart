import 'package:blin/get/app_controller.dart';
import 'package:blin/services/app_init_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class User {
  String id;
  String name;

  User({required this.id, required this.name});

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  static Future<void> loginLocallyFromJWT(String token, String url) async {
    // Save the token to the app controller
    AppController.to.apiToken.value = token;
    await GetStorage().write("api_token", token);

    // Save the server URL to the preferences
    AppController.to.serverUrl.value = url;
    await GetStorage().write("server_url", url);

    // Create a user from the token and save it to the app controller
    AppController.to.user = User.fromJson(Jwt.parseJwt(token));

    // Set the logged in flag to true
    AppController.to.isLoggedIn.value = true;

    // Download user data
    await AppInitService.downloadUserData();
  }

  static Future<void> logoutLocally() async {
    // Remove the token from app controller and local storage
    AppController.to.apiToken.value = "";
    await GetStorage().write("api_token", "");

    // Reset the user object in the app controller
    AppController.to.user = null;

    // Set the logged in flag to false
    AppController.to.isLoggedIn.value = false;

    // Remove user data
    AppController.to.categories.value = [];
  }
}
