import 'package:bid/components/my_appbar.dart';
import 'package:bid/components/my_button.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/my_drawer.dart';
import 'package:bid/modals/loginpage.dart';
import 'package:bid/modals//registrationpage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            MyButton(
              text: "Login",
              onTap: () {
                // Show login modal
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LoginPage(
                      onTap: () {
                        // Navigate to RegistrationPage when tapping 'Register here'
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RegistrationPage(
                              onTap: () {
                                Navigator.pop(context); // Close the modal
                              },
                            );
                          },
                        );
                      },
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
                        // Navigate to LoginPage when tapping 'Login here'
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LoginPage(
                              onTap: () {
                                Navigator.pop(context); // Close the modal
                              },
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
        ),
    );
  }
}
