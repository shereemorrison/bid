import 'dart:convert';
import 'package:bid/respositories/base_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


class PaymentRepository extends BaseRepository {
  PaymentRepository({SupabaseClient? client}) : super(client: client);

  // Initialize Stripe - called in main.dart
  static Future<void> initStripe() async {
    Stripe.publishableKey = 'pk_test_51RG63pBLQQ4dypXtam2LgVa0Z7eqbR2EKEekCIp8iy7X4iiuRP1lGfMMAfsdwqKrsqyUez6Nal6XVeccP9Feug0U00RY0YG5ZI';
    await Stripe.instance.applySettings();
  }

  // Create payment intent via Supabase Edge Function
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      print('Creating payment intent: amount=$amount, currency=$currency');

      final response = await client.functions.invoke(
        'create-payment-intent',
        body: {
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency,
        },
      );

      print('Edge Function response: ${response.data}');

      // Handle response data
      Map<String, dynamic> paymentIntentData;

      if (response.data is Map) {
        print('Response is already a Map');
        paymentIntentData = Map<String, dynamic>.from(response.data as Map);
      } else if (response.data is String) {
        print('Response is a String, decoding JSON');
        paymentIntentData = jsonDecode(response.data as String);
      } else {
        print('Unexpected response type: ${response.data.runtimeType}');
        throw Exception('Unexpected response format: ${response.data.runtimeType}');
      }

      // Validate response contains client secret
      if (!paymentIntentData.containsKey('clientSecret')) {
        print('Response does not contain clientSecret: $paymentIntentData');
        throw Exception('Invalid response from payment service: missing client secret');
      }

      return paymentIntentData;
    } catch (e) {
      print('Payment intent error: $e');
      rethrow;
    }
  }

  Future<bool> processPayment({
    required String orderId,
    required String paymentMethodId,
    required double amount,
    required String currency,
  }) async {
    try {
      // Payment processing logic
      final response = await client.functions.invoke(
        'process-payment',
        body: {
          'orderId': orderId,
          'paymentMethodId': paymentMethodId,
          'amount': amount,
          'currency': currency,
        },
      );

      if (response.status != 200) {
        throw Exception('Payment processing failed: ${response.data}');
      }

      return true;
    } catch (e) {
      print('Error processing payment: $e');
      return false;
    }
  }
}
