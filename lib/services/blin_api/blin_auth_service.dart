import 'package:blin/services/http_service.dart';
import 'package:http/http.dart' as http;

class BlinAuthService {
  static const String route = "/auth";

  static Future<String> auth(String username, String password) async {
    Map<String, String> credentials = {
      "name": username,
      "password": password,
    };

    String? error;
    String? token;

    try {
      http.Response res = await http.post(
        HttpService.endpointUri(route, ""),
        body: credentials,
      );
      if (res.statusCode == 200) {
        token = res.body;
      } else if (res.statusCode == 400) {
        error = "Wrong username or password";
      } else {
        error = "Unknown error";
      }
    } catch (e) {
      error = "Couldn't connect to server";
    }

    if (error != null) {
      throw error;
    } else {
      return token!;
    }
  }
}
