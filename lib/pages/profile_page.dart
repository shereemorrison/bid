
import 'package:flutter/material.dart';
import 'package:bid/components/my_button.dart';
import 'package:bid/modals/loginmodal.dart';
import 'package:bid/modals/registrationmodal.dart';
import 'package:provider/provider.dart';
import 'package:bid/auth/auth_provider.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    // Access AuthProvider to check if the user is logged in
    final authProvider = Provider.of<AuthProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 30),
          Text(
            "B E L I E V E  I N  D R E A M S",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 30),
          if (authProvider.isLoggedIn) ...[
            // When logged in
            Text("Logged in as ${authProvider.user?.email ?? 'User'}",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 15),
            MyButton(
              text: "Log out",
              onTap: () async {
                await authProvider.signOut(); // Log out action
              },
            ),
          ] else ...[

            // When not logged in
            MyButton(
              text: "Login",
              onTap: () {

                // Show login modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LoginPage(
                      onTap: () {

                        // Use login provider to sign in
                        authProvider.signIn('email', 'password');
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 15),
            MyButton(
              text: "Sign Up",
              onTap: () {

                // Show registration modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RegistrationPage(
                      onTap: () {

                        // Register and then log in after registration
                        authProvider.signIn('email', 'password');
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 15),

            // Social Login Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {

                    // Handle Instagram login
                    print("Instagram login");
                  },
                  child: Image.asset(
                    'assets/images/instagram.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {

                    // Handle Facebook login
                    print("Facebook login");
                  },
                  child: Image.asset(
                    'assets/images/facebook.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {

                    // Handle Twitter login
                    print("Twitter login");
                  },
                  child: Image.asset(
                    'assets/images/twitter.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
