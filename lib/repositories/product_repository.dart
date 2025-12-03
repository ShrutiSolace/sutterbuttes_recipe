import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/product_model.dart';
import '../modal/trending_product_model.dart';
import '../services/secure_storage.dart';
import '../repositories/product_repository.dart';

class ProductRepository {

 //product list api
  Future<List<Product>> getProducts({int page = 1, int perPage = 40}) async {
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


  //product detail api
  Future<Product> getProductDetail(int id) async {
    print("Fetching product details for ID: $id");

    try {
      // Build URI for single product
      Uri uri = Uri.parse("${ApiConstants.productdetailUrl}$id").replace(
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



  //trending products api
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


  //product by slug api
  Future<Product> getProductBySlug(String slug) async {
    print("Fetching product by slug: $slug");

    try {

      Uri uri = Uri.parse(ApiConstants.productListUrl).replace(
        queryParameters: {
          'consumer_key': ApiConstants.consumerKey,
          'consumer_secret': ApiConstants.consumerSecret,
          'slug': slug,
        },
      );


      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("++++++Slug product URL++++++");
      print("URL: $uri");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");


      if (response.statusCode == 200) {
        print("Response Body: ${response.body}");
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isEmpty) {
          throw Exception('Product not found with slug: $slug');
        }

        return Product.fromJson(jsonData[0]);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product by slug: $e');
    }
  }











}