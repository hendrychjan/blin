import 'package:blin/get/app_controller.dart';
import 'package:blin/services/app_init_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert' as conv;

class User {
  String id;
  String name;

  User({required this.id, required this.name});

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map["id"],
        name: map["name"],
      );

  factory User.fromJson(String json) =>
      User.fromMap(conv.json.decode(json) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };

  String toJson() => conv.json.encode(toMap());

  static Future<void> loginLocallyFromJWT(String token, String url) async {
    // Save the token to the app controller
    AppController.to.apiToken.value = token;
    await GetStorage().write("api_token", token);

    // Save the server URL to the preferences
    AppController.to.serverUrl.value = url;
    await GetStorage().write("server_url", url);

    // Create a user from the token and save it to the app controller
    AppController.to.user = User.fromMap(Jwt.parseJwt(token));

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
