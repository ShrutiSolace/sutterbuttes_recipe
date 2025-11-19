import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sutterbuttes_recipe/repositories/profile_repository.dart';
import '../api_constant.dart';
import '../modal/order_list_model.dart';
import '../modal/order_model.dart';
import '../modal/single_order_detail_model.dart';
import '../services/secure_storage.dart';

class OrderRepository {

 /* Future<List<OrderModel>> getOrders({int page = 1, int perPage = 10}) async {
    Uri uri = Uri.parse('${ApiConstants.ordersUrl}?per_page=$perPage&page=$page').replace(
      queryParameters: {
        'consumer_key': ApiConstants.consumerKey,
        'consumer_secret': ApiConstants.consumerSecret,
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print("Url: $uri");
    print("Order Response: ${response.statusCode} :: ${response.body}");

    print("status code: ${response.statusCode}");
    print("Response body: ${response.body}");


    if (response.statusCode == 200) {
      print("=======");
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      List<OrderModel>  list = data.map((e) => OrderModel.fromJson(e)).toList();
      return list;
    } else if (response.statusCode == 401) {
      print("======");
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      print("=======");
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  }


*/

  Future<int> getOrderCount() async {
    print("=======Fetching order count...");

    String? token = await SecureStorage.getLoginToken();

    if (token == null) {
      return 0;
    }


    try {
      final profileRepo = UserRepository();
      final profile = await profileRepo.getCurrentUser();
      final customerId = profile.id;


      Uri uri = Uri.parse('${ApiConstants.ordersUrl}?per_page=1&page=1&customer=$customerId');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print("Order Count URL: $uri");
      print("Order Count Response: ${response.statusCode} :: ${response.body}");

      if (response.statusCode == 200) {
        final totalCountHeader = response.headers['x-wp-total'];
        if (totalCountHeader != null) {
          return int.tryParse(totalCountHeader) ?? 0;
        }

        final List<dynamic> data = json.decode(response.body) as List<dynamic>;
        return data.length;
      } else if (response.statusCode == 401) {
        return 0;
      } else if (response.statusCode == 403) {
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      print("Error getting order count: $e");
      return 0; // Return 0 if any error occurs
    }
  }


  Future<List<OrderSummary>> getOrdersList({int page = 1, int perPage = 10}) async {
    String? token = await SecureStorage.getLoginToken();

    if (token == null) {
      throw Exception('User not authenticated. Please login first.');
    }

    Uri uri = Uri.parse('${ApiConstants.orderslistUrl}?per_page=$perPage&page=$page');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
   print("=======");
    print("Orders List URL: $uri");
    print("Orders List Response: ${response.statusCode} :: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final ordersResponse = OrdersListResponse.fromJson(data);
      return ordersResponse.orders ?? <OrderSummary>[];
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else {
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  }


  Future<OrderDetail> getOrderDetail(int orderId) async {

    String? token = await SecureStorage.getLoginToken();

    if (token == null) {
      throw Exception('User not authenticated. Please login first.');
    }

    Uri uri = Uri.parse('${ApiConstants.orderDetailUrl}$orderId');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print("====");
    print("Order Detail URL: $uri");
    print("Order Detail Response: ${response.statusCode} :: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final orderDetailResponse = OrderDetailResponse.fromJson(data);
      return orderDetailResponse.order!;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please login again.');
    } else {
      throw Exception('Failed to fetch order detail: ${response.statusCode}');
    }
  }

  Future<int> getCount() async {
    String? token = await SecureStorage.getLoginToken();
    if (token == null) return 0;

    try {
      final orders = await getOrdersList(page: 1, perPage: 1000);
      return orders.length;
    } catch (e) {
      return 0;
    }
  }

}
/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/order_model.dart';
import '../services/secure_storage.dart';

class OrderRepository {
  Future<List<OrderModel>> getOrders({int page = 1, int perPage = 10}) async {

    final uri = Uri.parse('${ApiConstants.ordersUrl}?per_page=$perPage&page=$page');

     String ? token = await SecureStorage.getLoginToken();
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

    print("status code: ${response.statusCode}");
    print("Response body: ${response.body}");


    if (response.statusCode == 200) {
      print("=======");
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      List<OrderModel>  list = data.map((e) => OrderModel.fromJson(e)).toList();
      return list;
    } else if (response.statusCode == 401) {
      print("======");
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      print("=======");
      throw Exception('Failed to fetch orders: ${response.statusCode}');
    }
  }
}


 */