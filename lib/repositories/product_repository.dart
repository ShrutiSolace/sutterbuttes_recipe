import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/product_model.dart';
import '../modal/trending_product_model.dart';
import '../services/secure_storage.dart';


class ProductRepository {


  Future<List<Product>> getProducts({int page = 1, int perPage = 30}) async {
    print("Fetching products from API...");

    try {

      Uri uri = Uri.parse(ApiConstants.productListUrl).replace(
        queryParameters: {
          'consumer_key': ApiConstants.consumerKey,
          'consumer_secret': ApiConstants.consumerSecret,
          'per_page': perPage.toString(),
          'page': page.toString(),
        },
      );


      final response = await http.get(
        uri,
        headers: {

          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print("URL: $uri");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Request URL: $uri");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);



        List<Product> products = jsonData
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        // ADD THIS LINE HERE to see the count:
        print("=== TOTAL PRODUCTS FROM API: ${products.length} ===");
        return products;


      } else {
        // Handle error response
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product> getProductDetail(int id) async {
    print("Fetching product details for ID: $id");

    try {
      // Build URI for single product
      Uri uri = Uri.parse("${ApiConstants.productdetailUrl}/$id").replace(
        queryParameters: {
          'consumer_key': ApiConstants.consumerKey,
          'consumer_secret': ApiConstants.consumerSecret,
        },
      );

      // Make HTTP GET request
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("URL: $uri");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Product.fromJson(jsonData);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }




  Future<TrendingProductModel> getTrendingProducts() async {
    print("Fetching trending products");

    try {
      final uri = Uri.parse(ApiConstants.trendingProductsUrl);
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("Request URL: $uri");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TrendingProductModel.fromJson(data);
      } else {
        throw Exception("Failed to fetch trending products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching trending products: $e");
    }
  }













}