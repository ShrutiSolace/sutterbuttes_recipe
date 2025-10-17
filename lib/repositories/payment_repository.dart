import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../api_constant.dart';
import '../services/secure_storage.dart';

class PaymentRepository {


  Future<bool> createStripePaymentIntent({required int orderId, required String paymentIntentId}) async {
    final String? token = await SecureStorage.getLoginToken();
    final uri = Uri.parse(ApiConstants.stripeCreateIntentUrl);

    Map request = {
      'order_id': orderId,
      'payment_intent_id': paymentIntentId,
    };

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(request),
    );

    // Debug logs to diagnose 4xx/5xx issues
    // Note: Remove or lower verbosity in production
    // ignore: avoid_print
    print('[Stripe Intent] POST ${uri.toString()}');
    // ignore: avoid_print
    print('[Stripe Intent] Payload: ' + json.encode(request));
    // ignore: avoid_print
    print('[Stripe Intent] Status: ${response.statusCode}');
    // ignore: avoid_print
    print('[Stripe Intent] Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;

      return true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized (401). Token may be expired/invalid.');
    } else if (response.statusCode == 404) {
      throw Exception('Failed to create payment intent: 404 (endpoint not found). Check ApiConstants.stripeCreateIntentUrl and backend route.');
    } else {
      throw Exception('Failed to create payment intent: ${response.statusCode}');
    }
  }
}


