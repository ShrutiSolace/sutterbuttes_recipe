import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/recipe_model.dart';
import '../modal/trending_recipes_model.dart';

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
    print("request url : $Uri");
    print("Request URL: ${ApiConstants.recipesListUrl}?_embed=1&page=$page&per_page=$perPage");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data.map((item) => RecipeItem.fromJson(item as Map<String, dynamic>)).toList();
    }
    else {
            throw Exception("Something went wrong, please try again later");
          }
  }
  // else {
  //       throw Exception("Failed to fetch recipes: ${response.statusCode}");
  //     }

  Future<TrendingRecipesModel> getTrendingRecipes() async {

    print("Fetching trending recipes");
    print("======================================");
    final uri = Uri.parse(ApiConstants.trendingRecipesUrl);
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("Request URL: $uri");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print(response.body.length > 1000
        ? response.body.substring(0, 1000) + '... [truncated]'
        : response.body);
    print('Response Body End ');
    print('======================================');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return TrendingRecipesModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch trending recipes: ${response.statusCode}");
    }
  }
}
