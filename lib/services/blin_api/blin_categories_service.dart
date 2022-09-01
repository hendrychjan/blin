import 'dart:convert';
import 'package:blin/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:blin/services/http_service.dart';

class BlinCategoriesService {
  static String route = "/categories";

  static Future<List<Category>> getAllCategories() async {
    http.Response res = await http.get(
      HttpService.endpointUri(route, ""),
      headers: HttpService.getHeaders(),
    );

    List<dynamic> payload = jsonDecode(res.body);
    return payload.map((e) => Category.fromMap(e)).toList();
  }

  static Future<Category> createNewCategory(Map payload) async {
    http.Response res = await http.post(
      HttpService.endpointUri(route, ""),
      headers: HttpService.getHeaders(),
      body: jsonEncode(payload),
    );

    return Category.fromJson(res.body);
  }

  static Future<Category> updateCategory(Map payload, String id) async {
    http.Response res = await http.put(
      HttpService.endpointUri(route, "/$id"),
      headers: HttpService.getHeaders(),
      body: jsonEncode(payload),
    );

    return Category.fromMap(jsonDecode(res.body));
  }

  static Future<void> deleteCategory(String id) async {
    await http.delete(
      HttpService.endpointUri(route, "/$id"),
      headers: HttpService.getHeaders(),
    );
  }
}
