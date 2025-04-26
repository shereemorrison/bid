import 'package:supabase_flutter/supabase_flutter.dart';

class NewsletterService {
  final SupabaseClient _supabase;

  NewsletterService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Subscribe an email to the newsletter
  Future<bool> subscribeToNewsletter(String email, {String? userId}) async {
    try {
      // Check if already subscribed
      final existing = await _supabase
          .from('newsletter_subscribers')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (existing != null) {
        // Already subscribed, update to active if needed and update user_id if provided
        Map<String, dynamic> updateData = {'is_active': true};

        // Only update user_id if it's provided and the existing one is null
        if (userId != null && existing['user_id'] == null) {
          updateData['user_id'] = userId;
        }

        await _supabase
            .from('newsletter_subscribers')
            .update(updateData)
            .eq('email', email);

        return true;
      }

      // Add new subscriber
      await _supabase.from('newsletter_subscribers').insert({
        'email': email,
        'user_id': userId, // Will be null for anonymous subscribers
        'is_active': true,
      });

      return true;
    } catch (e) {
      print('Error subscribing to newsletter: $e');
      return false;
    }
  }

  /// Unsubscribe an email from the newsletter
  Future<bool> unsubscribeFromNewsletter(String email) async {
    try {
      await _supabase
          .from('newsletter_subscribers')
          .update({'is_active': false})
          .eq('email', email);
      return true;
    } catch (e) {
      print('Error unsubscribing from newsletter: $e');
      return false;
    }
  }

  /// Update the user_id for an existing newsletter subscription
  Future<bool> updateNewsletterUserId(String email, String userId) async {
    try {
      final existing = await _supabase
          .from('newsletter_subscribers')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (existing != null) {
        await _supabase
            .from('newsletter_subscribers')
            .update({'user_id': userId})
            .eq('email', email);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating newsletter user ID: $e');
      return false;
    }
  }
}

