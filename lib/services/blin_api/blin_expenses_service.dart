import 'dart:convert';
import 'package:blin/models/expense.dart';
import 'package:blin/services/http_service.dart';
import 'package:http/http.dart' as http;

class BlinExpensesService {
  static String route = "/expenses";

  static Future<List<Expense>> getAllExpenses() async {
    http.Response res = await http.get(
      HttpService.endpointUri(route, ""),
      headers: HttpService.getHeaders(),
    );

    List<dynamic> payload = jsonDecode(res.body);
    return payload.map((e) => Expense.fromMap(e)).toList();
  }

  static Future<Expense> createNewExpense(Map payload) async {
    http.Response res = await http.post(
      HttpService.endpointUri(route, ""),
      headers: HttpService.getHeaders(),
      body: jsonEncode(payload),
    );

    return Expense.fromJson(res.body);
  }

  static Future<Expense> updateExpense(Map payload, String id) async {
    http.Response res = await http.put(
      HttpService.endpointUri(route, "/$id"),
      headers: HttpService.getHeaders(),
      body: jsonEncode(payload),
    );

    return Expense.fromJson(res.body);
  }

  static Future<void> deleteExpense(String id) async {
    await http.delete(
      HttpService.endpointUri(route, "/$id"),
      headers: HttpService.getHeaders(),
    );
  }
}
