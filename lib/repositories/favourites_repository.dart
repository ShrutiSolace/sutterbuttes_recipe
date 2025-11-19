import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/favourites_model.dart';
import '../services/secure_storage.dart';

class FavouritesRepository {
  Future<FavouritesModel> getFavourites() async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.favouritesUrl);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
     print("Url: $uri");
     print("Favourites Response: ${response.statusCode} :: ${response.body}");
     print("Token: $token");
     print("status code: ${response.statusCode}");
      print("Response body: ${response.body}");


    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return FavouritesModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to fetch favourites: ${response.statusCode}');
    }
  }

  Future<bool> toggleFavourite({required String type, required int id}) async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.favouritesUrl);

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'type': type,
        'id': id,
      }),
    );

    print("url: $uri");
    print("Response body: ${response.body}");
    print("Request body: ${response.request}");
    print("status code: ${response.statusCode}");
    print("Token: $token");


      if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['success'] == true);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else {
      throw Exception('Failed to update favourite: ${response.statusCode}');
    }
  }
}


