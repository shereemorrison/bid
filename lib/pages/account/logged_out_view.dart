import 'package:bid/components/auth/login_form.dart';
import 'package:bid/components/auth/register_form.dart';
import 'package:bid/components/buttons/auth_button.dart';
import 'package:bid/components/common_widgets/profile_header.dart';
import 'package:bid/components/common_widgets/social_login_row.dart';
import 'package:flutter/material.dart';

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

          AuthButton(
            text: "Login",
            onTap: () => _showLoginModal(context),
          ),
          const SizedBox(height: 15),
          AuthButton(
            text: "Sign Up",
            onTap: () => _showRegistrationModal(context),
          ),
          const SizedBox(height: 15),
          const SocialLoginRow(),
        ],
      ),
    );
  }

  void _showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
        ),
        child: LoginForm(
        onLoginSuccess: () => Navigator.pop(context),
        onCancel: () => Navigator.pop(context),
        onRegisterInstead: () {
        Navigator.pop(context);
        _showRegistrationModal(context);
          },
        ),
        );
      },
    );
  }

  void _showRegistrationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
        ),
        child: RegisterForm(
        onRegisterSuccess: () => Navigator.pop(context),
        onCancel: () => Navigator.pop(context),
        onLoginInstead: () {
        Navigator.pop(context);
        _showLoginModal(context);
          }
        ),
        );
      },
    );
  }
}
