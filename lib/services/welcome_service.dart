
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_config.dart';

class WelcomeService {
  String userName = '';
  int currentPage = 0;
  Timer? carouselTimer;

  final List<String> mainImagePaths = [
    'assets/images/BIDHoodie.jpg',
    'assets/images/BIDTshirt.jpg',
    'assets/images/BIDSweater.jpg'
  ];

  final List<String> imagePaths = [
    'assets/images/BIDHoodie2.jpg',
    'assets/images/BIDHoodie3.jpg',
    'assets/images/BIDHoodie4.jpg',
    'assets/images/BIDSweater2.jpg',
    'assets/images/BIDHoodie4.jpg'
  ];

  WelcomeService() {
    startCarouselTimer();
  }

  void startCarouselTimer() {
    carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }
    });
  }

  void dispose() {
    carouselTimer?.cancel();
  }

  Future<void> getUserName() async {
    final user = SupabaseConfig.client.auth.currentUser;
    if (user != null) {
      // Try to get user metadata or profile info
      try {
        final userMetadata = user.userMetadata;
        if (userMetadata != null && userMetadata.containsKey('name')) {
          userName = userMetadata['name'] as String;
        } else {
          userName = user.email?.split('@').first ?? 'Guest';
        }
      } catch (e) {
        userName = user.email?.split('@').first ?? 'Guest';
      }
    } else {
      userName = 'Guest';
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}