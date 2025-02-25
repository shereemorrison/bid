import 'package:bid/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/my_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  //login method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')), // Added AppBar for context
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Centers vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Centers horizontally
          children: [
            const SizedBox(height: 200),

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
                  Navigator.pushNamed(context, '/register_page');
                }
            ),
          ],
        ),
      ),
    );
  }
}
