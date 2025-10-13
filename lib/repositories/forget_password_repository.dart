import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../modal/forget_password_model.dart';
import '../services/secure_storage.dart';


class ForgetPasswordRepository{
Future<ForgetPasswordModel> forgotPassword({required String email}) async {

  print("Initiating forgot password for email: $email");

  final uri = Uri.parse(ApiConstants.forgotPasswordUrl);
  final body = json.encode({
    'email': email,
  });


  final response = await http.post(
    uri,
    headers: {
      //'Authorization':
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: body,
  );

  print("URL: $uri");
  print("Response Status: ${response.statusCode}");
  print("Response Body: ${response.body}");

  final Map<String, dynamic> data = json.decode(response.body);

  if (response.statusCode == 200) {
    return ForgetPasswordModel.fromJson(data);
  } else {
    throw Exception(data['message'] ?? 'Failed to send reset email: ${response.statusCode}');
  }
}
}