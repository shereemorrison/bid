// import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'checkout_session_manager.dart';
// import '../providers/supabase_auth_provider.dart';
// import '../providers/shop_provider.dart';
//
// /// Service responsible for clearing user data
// ///
// /// This service:
// /// - Clears checkout session data
// /// - Clears cart, wishlist, and other user-specific data
// /// - Ensures data from one user doesn't persist to another
// class DataClearingService {
//   final SupabaseClient _supabase;
//   final riverpod.Ref _ref;
//
//   DataClearingService(this._supabase, this._ref);
//
//   // Clear all user data on logout
//   Future<void> clearDataOnLogout() async {
//     try {
//       // 1. Clear checkout session
//       _ref.read(checkoutSessionManagerProvider).clearCheckoutSession();
//
//       // 2. Clear cart
//       _ref.read(cartProvider.notifier).state = [];
//
//       // 3. Clear other user-specific data
//       // Add any other providers that need to be cleared
//
//       print('Successfully cleared all user data on logout');
//     } catch (e) {
//       print('Error clearing user data: $e');
//     }
//   }
//
//   // Clear guest data when a user logs in
//   Future<void> clearGuestDataOnLogin() async {
//     try {
//       // Check if there's an active checkout session for a guest
//       final sessionManager = _ref.read(checkoutSessionManagerProvider);
//       final currentSession = sessionManager.getCurrentSession();
//
//       if (currentSession != null && currentSession.isGuestCheckout) {
//         // Clear the guest checkout session
//         sessionManager.clearCheckoutSession();
//         print('Cleared guest checkout session on login');
//
//         // Initialize a new session for the logged-in user
//         final authUserId = _ref.read(authUserIdProvider);
//         if (authUserId != null) {
//           sessionManager.initializeCheckoutSession(
//             userId: authUserId,
//             isGuestCheckout: false,
//           );
//         }
//       }
//     } catch (e) {
//       print('Error clearing guest data: $e');
//     }
//   }
// }
//
// // Provider for the data clearing service
// final dataClearingServiceProvider = riverpod.Provider<DataClearingService>((ref) {
//   final supabase = Supabase.instance.client;
//   return DataClearingService(supabase, ref);
// });
