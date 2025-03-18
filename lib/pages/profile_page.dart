
/*import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid/components/widgets/profile_header.dart';
import 'package:bid/components/buttons/auth_button.dart';
import 'package:bid/components/widgets/social_login_row.dart';
import 'package:bid/modals/loginmodal.dart';
import 'package:bid/modals/registrationmodal.dart';
import '../providers/supabase_auth_provider.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SupabaseAuthProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfileHeader(),
          const SizedBox(height: 30),

          if (authProvider.isLoggedIn)
            _buildLoggedInView(context, authProvider)
          else
            _buildLoggedOutView(context, authProvider),
        ],
      ),
    );
  }

  Widget _buildLoggedInView(BuildContext context, SupabaseAuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            "Logged in as ${authProvider.user?.email ?? 'User'}",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 4.0,
            ),
          ),
        ),
        const SizedBox(height: 15),
        AuthButton(
          text: "Log out",
          onTap: () async {
            await authProvider.signOut();
          },
        ),
      ],
    );
  }

  Widget _buildLoggedOutView(BuildContext context, SupabaseAuthProvider authProvider) {
    return Column(
      children: [
        AuthButton(
          text: "Login",
          onTap: () => _showLoginModal(context, authProvider),
        ),
        const SizedBox(height: 15),
        AuthButton(
          text: "Sign Up",
          onTap: () => _showRegistrationModal(context, authProvider),
        ),
        const SizedBox(height: 15),
        const SocialLoginRow(),
      ],
    );
  }

  void _showLoginModal(BuildContext context, SupabaseAuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoginPage(
          onTap: () {
            authProvider.signIn('email', 'password');
          },
        );
      },
    );
  }

  void _showRegistrationModal(BuildContext context, SupabaseAuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegistrationPage(
          onTap: () {
            authProvider.signIn('email', 'password');
          },
        );
      },
    );
  }
}*/