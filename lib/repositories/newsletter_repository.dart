import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/newsletter_model.dart';
import '../services/secure_storage.dart';

class NewsletterRepository {

  Future<NewsletterResponse> getNewsletterData() async {
    try {
      String? token = await SecureStorage.getLoginToken();


      final response = await http.get(Uri.parse(ApiConstants.newsletterUrl),

        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print("token: $token");
      print("Fetching newsletter from: ${ApiConstants.newsletterUrl}");
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");


      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          return NewsletterResponse.fromJson(responseData);
        } else {
          throw Exception(responseData['message'] ?? "Invalid response format");
        }
      } else if (response.statusCode == 401) {
        throw Exception("Your session expired. Please login again.");
      } else if (response.statusCode == 403) {
        throw Exception("Access denied. Please contact support.");
      } else {
        throw Exception("Failed to load newsletter. [${response.statusCode}]");
      }
    } catch (error) {
      print("Error fetching newsletter: $error");
      throw Exception("Failed to load newsletter: $error");
    }
  }

 //subscribe
// Add this method to your existing NewsletterRepository class

  Future<NewsletterSubscribeResponse> subscribeToNewsletter({

    required String email,
    required String name,
    required bool newRecipes,
    required bool cookingTips,
    required bool seasonalOffers,
    required bool productUpdates,
  })

  async {
    try {

      String? token = await SecureStorage.getLoginToken();

      final request = NewsletterSubscribeRequest(
        email: email,
        name: name,
        newRecipes: newRecipes,
        cookingTips: cookingTips,
        seasonalOffers: seasonalOffers,
        productUpdates: productUpdates,
      );

      final response = await http.post(
        Uri.parse(ApiConstants.subscriberUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      print("Token: $token");
      print("Newsletter Subscribe URL: ${ApiConstants.subscriberUrl}");
      print("Newsletter Subscribe Request Body: ${json.encode(request.toJson())}");
      print("Newsletter Subscribe Response Status: ${response.statusCode}");
      print("Newsletter Subscribe Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return NewsletterSubscribeResponse.fromJson(responseData);
      } else {
        throw Exception("Failed to subscribe to newsletter. [${response.statusCode}]");
      }
    } catch (error) {
      print("Error subscribing to newsletter: $error");
      throw Exception("Failed to subscribe to newsletter: $error");
    }
  }


  //unsubscribe
// Add this method to your existing NewsletterRepository class

  Future<Map<String, dynamic>> unsubscribeFromNewsletter() async {
    try {

      String? token = await SecureStorage.getLoginToken();

      final response = await http.post(
        Uri.parse(ApiConstants.unsubscribeUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
           'Authorization': 'Bearer $token',
        },
      );

      print(" URL: ${ApiConstants.unsubscribeUrl}");
      print(" Response Code: ${response.statusCode}");
      print(" Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception("Failed to unsubscribe from newsletter. [${response.statusCode}]");
      }
    } catch (error) {
      print("Error unsubscribing from newsletter: $error");
      throw Exception("Failed to unsubscribe from newsletter: $error");
    }
  }






}

