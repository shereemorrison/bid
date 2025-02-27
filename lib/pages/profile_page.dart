import 'package:bid/components/my_button.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/my_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  //login method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Profile")
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Centers vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
            children: [
              Icon(Icons.person,
            size: 60,
            color: Theme.of(context).colorScheme.inversePrimary,
              ),

            const SizedBox(height: 100),

              MyButton(
                text: "Login",
                onTap: () {
                  Navigator.pushNamed(context, '/login_page');
                }
                ),

              const SizedBox(height: 15), // Adds space between buttons
      
              MyButton(
                  text: "Register",
                  onTap: () {
                    Navigator.pushNamed(context, '/registration_page');
                  }
              ),
            ],
          ),
        ),
    );
  }
}
