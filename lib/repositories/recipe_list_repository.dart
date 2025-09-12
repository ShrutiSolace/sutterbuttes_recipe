import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/recipe_model.dart';

class RecipeListRepository {
  Future<List<RecipeItem>> getRecipes({int page = 1, int perPage = 10}) async {
    print("Fetching recipes: page=$page, perPage=$perPage");
    print("getRecipes called with page: $page, perPage: $perPage");


    print("======================================");
    final response = await http.get(
      Uri.parse('${ApiConstants.recipesListUrl}?_embed=1&page=$page&per_page=$perPage'),
      headers: {

        "Content-Type": "application/json",
      },
    );

    print("Request URL: ${ApiConstants.recipesListUrl}?_embed=1&page=$page&per_page=$perPage");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data.map((item) => RecipeItem.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception("Failed to fetch recipes: ${response.statusCode}");
    }
  }
}
