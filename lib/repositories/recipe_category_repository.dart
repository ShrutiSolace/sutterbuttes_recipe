import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/recipe_category_model.dart';


class RecipeCategoryRepository {
  final String token;

  RecipeCategoryRepository(this.token);

  Future<RecipeCategoriesResponse> getRecipeCategories() async {
    final response = await http.get(
      Uri.parse(ApiConstants.recipesCategoryListUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("Using Token: $token");
    print("Request URL: ${ApiConstants.recipesCategoryListUrl}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return RecipeCategoriesResponse.fromJson(data);
    } else {
      throw Exception("Failed to fetch categories: ${response.statusCode}");
    }
  }
}
