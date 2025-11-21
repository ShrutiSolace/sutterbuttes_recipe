import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/cart_model.dart';
import '../modal/shipping_cost_model.dart';
import '../services/secure_storage.dart';


class CartRepository {
  Future<CartModel> addToCart({required int productId, required int quantity , int? variationId}) async {
    print("Adding to cart: productId=$productId, quantity=$quantity , variationId=$variationId");

    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.cartAddUrl);

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },

      body: json.encode({
        'product_id': productId,
        if (variationId!= null )'variation_id': variationId,
        'quantity': quantity,
      }),
    );
    print("===ADD to cart ");
    print("Staus code: ${response.statusCode}");
    print("url: $uri");
    print("Response body: ${response.body}");
    print("Request body: ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CartModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to add to cart: ${response.statusCode}');
    }
  }

  Future<CartModel> getCart() async {
    print("===GET CART ");
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.cartUrl);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    print("Staus code: ${response.statusCode}");
    print("url: $uri");
    print("Response body: ${response.body}");
    print("Request body: ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CartModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to fetch cart: ${response.statusCode}');
    }
  }

  Future<CartModel> updateCart({
    required int productId,
    required int variationId,
    required int quantity,
  }) async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.cartUpdateUrl);

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'product_id': productId,
        'variation_id': variationId,
        'quantity': quantity,
      }),
    );

    print("url: $uri");
    print("Response body: ${response.body}");
    print("Request body: ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CartModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to update cart: ${response.statusCode}');
    }
  }

  Future<CartModel> removeFromCart({
    required int productId,
    required int variationId,
  }) async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.cartRemoveUrl);

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'product_id': productId,
        'variation_id': variationId,
      }),
    );

    print("url: $uri");
    print("Response body: ${response.body}");
    print("Request body: ${response.request}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return CartModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to remove from cart: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> checkout({
    required Map<String, dynamic> billing,
    required Map<String, dynamic> shipping,
    required String paymentMethod,
  }) async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.checkoutUrl);

    final payload = json.encode({
      'billing': billing,
      'shipping': shipping,
      'payment_method': paymentMethod,
    });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: payload,
    );

    print("======== uri: $uri ");
    print("===== payload: $payload ");
    print("=== Response: ${response.statusCode} ${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Checkout failed: ${response.statusCode}');
    }
  }


  /*Future<ShippingCostModel> getShippingCost({
    required String address,
    required String city,
    required String state,
    required String postcode,
    required String country,
  }) async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.shippingUrl);

    final payload = json.encode({
      'shipping': {
        'address_1': address,
        'city': city,
        'state': state,
        'postcode': postcode,
        'country': country,
      }
    });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: payload,
    );

    print("======== Shipping Cost API ========");
    print("url: $uri");
    print("payload: $payload");
    print("Response: ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ShippingCostModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to get shipping cost: ${response.statusCode}');
    }
  }




*/

}


