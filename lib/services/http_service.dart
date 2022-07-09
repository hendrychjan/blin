import 'package:blin/get/app_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class HttpService {
  static Map<String, String> getHeaders() {
    return {
      "x-auth-token": AppController.to.apiToken.string,
      'Content-type': 'application/json',
    };
  }

  static Uri endpointUri(String route, String endpoint) {
    String protocol = AppController.to.serverUrl.string.split(":")[0];
    if (protocol == "https") {
      String authority =
          AppController.to.serverUrl.string.replaceAll("https://", "");
      return Uri.https(authority, route + endpoint);
    } else {
      String authority =
          AppController.to.serverUrl.string.replaceAll("http://", "");
      return Uri.http(authority, route + endpoint);
    }
  }

  static Future<bool> checkInternetConnection() async {
    var conn = await (Connectivity().checkConnectivity());

    if (conn == ConnectivityResult.none) {
      Get.snackbar("No internet", "Connect to the internet and try again.");
      return false;
    } else {
      return true;
    }
  }
}
