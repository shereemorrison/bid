import 'package:bid/config/api_keys.dart';
import 'package:bid/repositories/address_repository.dart';
import 'package:bid/repositories/newsletter_repository.dart';
import 'package:bid/repositories/order_repository.dart' as repo;
import 'package:bid/repositories/payment_repository.dart';
import 'package:bid/repositories/product_repository.dart';
import 'package:bid/repositories/user_repository.dart';
import 'package:bid/services/guest_order_service.dart';
import 'package:bid/services/mapbox_service.dart';
import 'package:bid/services/payment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(client: ref.watch(supabaseClientProvider));
});

final orderRepositoryProvider = Provider<repo.OrderRepository>((ref) {
  return repo.OrderRepository(client: ref.watch(supabaseClientProvider));
});

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(client: ref.watch(supabaseClientProvider));
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(client: ref.watch(supabaseClientProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(client: ref.watch(supabaseClientProvider));
});

final newsletterRepositoryProvider = Provider<NewsletterRepository>((ref) {
  return NewsletterRepository(client: ref.watch(supabaseClientProvider));
});

final guestOrderServiceProvider = Provider<GuestOrderService>((ref) {
  return GuestOrderService();
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(
    ref,
    ref.watch(paymentRepositoryProvider),
  );
});

final mapboxServiceProvider = Provider<MapboxService>((ref) {
  return MapboxService(apiKey: ApiKeys.mapboxApiKey);
});
