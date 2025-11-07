import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/rating_model.dart';

import '../services/secure_storage.dart';

class RatingsRepository {

  Future<RatingsModel> getRecipeRatings(int recipeId) async {
    print("Fetching ratings for recipe ID: $recipeId");

    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse('${ApiConstants.recipeRatingsUrl}/$recipeId/ratings');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    print("Status Code: ${response.statusCode}");
    print("Ratings URL: $uri");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return RatingsModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to fetch ratings: ${response.statusCode}');
    }
  }
}