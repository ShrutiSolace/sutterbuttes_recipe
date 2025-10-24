import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/search_model.dart';


class SearchRepository {
  Future<SearchResultModel> searchItems(String query) async {
    print("======Starting search for query: $query");


    try {
      // URL encode the query to handle special characters
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
        return SearchResultModel.fromJson(data);
      } else {
        throw Exception("Failed to search: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during search: $e");
    }
  }
}