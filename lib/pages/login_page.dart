import 'package:bid/components/my_button.dart';
import 'package:bid/components/my_drawer.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:bid/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  //text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap});

  //login method
  void login() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      //drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 60,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            // logo
            /* Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/Logo.png',
                width: 60,
                height: 60, */

            const SizedBox(height: 25),

            // Title
            Text(
              "B E L E I V E  I N  D R E A M S",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 40),

            // Email input field
            MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
            ),

            const SizedBox(height: 10),

            // Password input field
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
            ),

            const SizedBox(height: 10),

            //Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                  ),
              ],
            ),
            const SizedBox(height: 25),

            // Sign In Button
            MyButton(
                onTap: onTap,
                text: "Login",
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),

                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    " Register here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
