import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider; // Hide Provider from Supabase
import '../services/payment_service.dart';

// Provider for the PaymentService
final paymentServiceProvider = Provider<PaymentService>((ref) {
  final supabase = Supabase.instance.client;
  return PaymentService(supabase);
});

// Provider for payment processing state
final paymentProcessingProvider = StateProvider<bool>((ref) => false);

// Provider for payment result
final paymentResultProvider = StateProvider<String?>((ref) => null);