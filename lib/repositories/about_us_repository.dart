import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/about_us_model.dart';


class AboutContentRepository {


  Future<AboutContentModel> getAboutContent() async {
    final uri = Uri.parse(ApiConstants.aboutUsUrl);

    try {
      final response = await http.get(
        uri,
        headers: {

          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print("About Content URL: $uri");
      print("Status Code: ${response.statusCode}");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return AboutContentModel.fromJson(data);
      } else {
        throw Exception('Failed to load about content. Status code: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print("Network Error fetching about content: $e");
      throw Exception('Could not connect to the server. Please check your internet connection.');
    } catch (e) {
      print("General Error fetching about content: $e");
      throw Exception('An unexpected error occurred while fetching the content.');
    }
  }
}