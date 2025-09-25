import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/order_model.dart';
import '../services/secure_storage.dart';

class OrderRepository {
  Future<List<OrderModel>> getOrders({int page = 1, int perPage = 50}) async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse('${ApiConstants.ordersUrl}?per_page=$perPage&page=$page');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print("Url: $uri");
    print("Order Response: ${response.statusCode} :: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      List<OrderModel>  list = data.map((e) => OrderModel.fromJson(e)).toList();
      return list;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  }
}

