
import 'package:bid/components/buttons/auth_button.dart';
import 'package:bid/components/common_widgets/profile_header.dart';
import 'package:bid/components/common_widgets/social_login_row.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoggedOutView extends StatelessWidget {
  const LoggedOutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfileHeader(),
          const SizedBox(height: 30),

          Text(
            'You need to log in to view your profile',
            style: TextStyle(fontSize: 16, color: colorScheme.secondary),
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 20),

          AuthButton(
            text: "Login",
            onTap: () => context.push('/account/login'),
          ),
          const SizedBox(height: 15),
          AuthButton(
            text: "Sign Up",
            onTap: () => context.push('/account/register'),
          ),
          const SizedBox(height: 15),
          const SocialLoginRow(),
        ],
      ),
    );
  }
}