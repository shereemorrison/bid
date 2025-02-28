import 'package:flutter/material.dart';
import 'package:bid/components/my_button.dart';
import 'package:bid/modals/loginmodal.dart';
import 'package:bid/modals/registrationmodal.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState(); // Private State class
}

class _ProfilePageState extends State<ProfilePage> {  // Private State class
  bool isLoggedIn = false;

  void _logOut() {
    setState(() {
      isLoggedIn = false;  // Set logged-out state
    });
  }

  void _logIn() {
    setState(() {
      isLoggedIn = true;  // Set logged-in state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 60,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          const SizedBox(height: 30),
          Text("B E L I E V E  I N  D R E A M S"),
          const SizedBox(height: 30),
          if (isLoggedIn) ...[
            Text("Logged in"),  // When logged in
            const SizedBox(height: 15),
            MyButton(
              text: "Log out",
              onTap: _logOut,  // Log out action
            ),
          ] else ...[
            MyButton(
              text: "Login",
              onTap: () {
                // Show login modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LoginPage(
                      onTap: _logIn,  // Log in action
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 15),
            MyButton(
              text: "Register",
              onTap: () {
                // Show registration modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RegistrationPage(
                      onTap: () {
                        // Navigate to LoginPage after registration
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LoginPage(
                              onTap: _logIn,  // Log in after registration
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
