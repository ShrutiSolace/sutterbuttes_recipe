import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/search_model.dart';


class SearchRepository {
  Future<SearchResultModel> searchItems(String query) async {
    print("======Starting search for query: $query");


    try {

      final encodedQuery = Uri.encodeComponent(query);
      final uri = Uri.parse('${ApiConstants.searchUrl}?query=$encodedQuery');

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("Search URL: $uri");
      print("Search Response Status: ${response.statusCode}");
      print("Search Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // ADD THIS HERE:
        final resultsData = data['results'] ?? {};
        final recipesList = resultsData['recipes'] as List?;
        final productsList = resultsData['products'] as List?;

        print("==========================================");
        print("🔍 SEARCH API EXACT COUNT");
        print("Query: $query");
        print("Recipes: ${recipesList?.length ?? 0}");
        print("Products: ${productsList?.length ?? 0}");
        print("Total: ${(recipesList?.length ?? 0) + (productsList?.length ?? 0)}");
        print("==========================================");

        return SearchResultModel.fromJson(data);
      } else {
        throw Exception("Failed to search: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during search: $e");
    }
  }
}