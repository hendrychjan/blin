import 'dart:convert';
import 'package:blin/get/app_controller.dart';
import 'package:blin/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:blin/services/http_service.dart';

class BlinCategoriesService {
  static String route = "/categories";

  static Future<List<Category>> getAllCategories() async {
    try {
      http.Response res = await http.get(
        HttpService.endpointUri(route, ""),
        headers: HttpService.getHeaders(),
      );

      List<dynamic> payload = jsonDecode(res.body);
      return payload.map((e) => Category.fromJson(e)).toList();
    } catch (ex) {
      print(ex);
      throw "Failed to fetch categories";
    }
  }

  static Future<Category> createNewCategory(Category category) async {
    try {
      http.Response res = await http.post(
        HttpService.endpointUri(route, ""),
        headers: HttpService.getHeaders(),
        body: jsonEncode(category.toJson()),
      );

      return Category.fromJson(jsonDecode(res.body));
    } catch (ex) {
      print(ex);
      throw "Failed to create category";
    }
  }

  static Future<Category> updateCategory(Category category) async {
    try {
      http.Response res = await http.put(
        HttpService.endpointUri(route, "/${category.id}"),
        headers: HttpService.getHeaders(),
        body: jsonEncode(category.toJson()),
      );
      print(AppController.to.categories);

      return Category.fromJson(jsonDecode(res.body));
    } catch (ex) {
      print(ex);
      throw "Failed to update category";
    }
  }

  static Future<void> deleteCategory(Category category) async {
    try {
      http.Response res = await http.delete(
        HttpService.endpointUri(route, "/${category.id}"),
        headers: HttpService.getHeaders(),
      );
    } catch (ex) {
      print(ex);
      throw "Failed to delete category";
    }
  }
}
