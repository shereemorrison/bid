
import 'package:flutter/material.dart';
import 'package:bid/components/buttons/social_login_button.dart';

class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          imagePath: 'assets/images/instagram.png',
          onTap: () {
            print("Instagram login");
          },
        ),
        const SizedBox(width: 10),
        SocialLoginButton(
          imagePath: 'assets/images/facebook.png',
          onTap: () {
            print("Facebook login");
          },
        ),
        const SizedBox(width: 10),
        SocialLoginButton(
          imagePath: 'assets/images/twitter.png',
          onTap: () {
            print("Twitter login");
          },
        ),
      ],
    );
  }
}