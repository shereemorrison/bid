import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  final SupabaseClient supabase;

  PaymentService(this.supabase);

  // Initialize Stripe - call this in your app initialization
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

      // Call your Supabase Edge Function
      final response = await supabase.functions.invoke(
        'create-payment-intent',
        body: {
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency,
        },
      );

      print('Edge Function response: ${response.data}');

      // Handle the response data correctly
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

      // Validate the response contains a client secret
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
}
