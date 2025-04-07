
import 'package:bid/services/dialog_service.dart';
import 'package:bid/services/newsletter_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsletterSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(bool success, String message)? onSubscriptionComplete;

  const NewsletterSection({
    Key? key,
    this.title = "JOIN THE JOURNEY",
    this.subtitle = "Subscribe to our newsletter and be the first to know about new collections, exclusive offers, and urban inspiration.",
    this.onSubscriptionComplete,
  }) : super(key: key);

  @override
  State<NewsletterSection> createState() => _NewsletterSectionState();
}

class _NewsletterSectionState extends State<NewsletterSection> {
  final TextEditingController _emailController = TextEditingController();
  final NewsletterService _newsletterService = NewsletterService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubscribe() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      widget.onSubscriptionComplete?.call(false, 'Please enter a valid email address');
      _showSnackBar('Please enter a valid email address', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user ID if logged in
      String? userId;
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        userId = user.id;
      }

      final success = await _newsletterService.subscribeToNewsletter(
          email,
          userId: userId
      );

      if (success) {
        _emailController.clear();
        widget.onSubscriptionComplete?.call(true, 'Successfully subscribed to newsletter!');

        // Use the DialogService instead of SnackBar
        DialogService.showNewsletterSubscriptionDialog(context, email);
      } else {
        widget.onSubscriptionComplete?.call(false, 'Failed to subscribe. Please try again.');
        _showSnackBar('Failed to subscribe. Please try again.', isError: true);
      }
    } catch (e) {
      widget.onSubscriptionComplete?.call(false, 'An error occurred: $e');
      _showSnackBar('An error occurred: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Your email address",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    "SUBSCRIBE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}