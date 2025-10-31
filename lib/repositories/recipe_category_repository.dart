import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/category_recipe_model.dart';
import '../modal/recipe_category_model.dart';
import '../services/secure_storage.dart';
import '../modal/recipe_model.dart';

class RecipeCategoryRepository {


  RecipeCategoryRepository();

  Future<RecipeCategoriesResponse> getRecipeCategories() async {

    final response = await http.get(
      Uri.parse(ApiConstants.recipesCategoryListUrl),
      headers: {

        "Content-Type": "application/json",
      },
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    print("recipe category Request URL: ${ApiConstants.recipesCategoryListUrl}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return RecipeCategoriesResponse.fromJson(data);
    } else {
      throw Exception("Failed to fetch categories: ${response.statusCode}");
    }
  }


 /* Future<List<CategoryRecipeItem>> getRecipesByCategory(int categoryId) async { // CHANGED RETURN TYPE
    print("Fetching recipes for category ID: $categoryId");

    String? token = await SecureStorage.getLoginToken();
    final url = Uri.parse('${ApiConstants.recipesByCategoryUrl}?category_id=$categoryId');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    print("Request URL: $url");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['recipes'] is List) {
        final List recipesJson = data['recipes'];
        return recipesJson
            .map((e) => CategoryRecipeItem.fromJson(e as Map<String, dynamic>)) // CHANGED HERE
            .toList();
      } else {
        return []; // Return empty list for unexpected format
      }
    } else {
      throw Exception("Failed to fetch recipes: ${response.statusCode}");
    }
  }*/
  Future<List<CategoryRecipeItem>> getRecipesByCategory(
      int categoryId, {
        int page = 1,
        int perPage = 20,
      }) async {
    print("Fetching recipes for category ID: $categoryId, page=$page, perPage=$perPage");

    String? token = await SecureStorage.getLoginToken();
    final url = Uri.parse(
      '${ApiConstants.recipesByCategoryUrl}?category_id=$categoryId&page=$page&per_page=$perPage',
    );

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print("=========================");

    print("Recipe by getRecipesByCategory");
    print("Request URL: $url");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['recipes'] is List) {
        final List recipesJson = data['recipes'];
        return recipesJson
            .map((e) => CategoryRecipeItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to fetch recipes: ${response.statusCode}");
    }
  }


}