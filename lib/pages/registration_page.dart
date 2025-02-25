import 'package:bid/components/my_button.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:bid/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  final void Function()? onTap;

  RegistrationPage({
    super.key,
    required this.onTap});

//text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();



  //register method
  void register() {}

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

            // Username textfield
            MyTextField(
              hintText: "Username",
              obscureText: false,
              controller: usernameController,
            ),

            const SizedBox(height: 10),

            // Email textfield
            MyTextField(
              hintText: "Email",
              obscureText: true,
              controller: emailController,
            ),

            const SizedBox(height: 10),

            //Password textfield
            MyTextField(
              hintText: "Enter Password",
              obscureText: false,
              controller: passwordController,
            ),

            const SizedBox(height: 10),

            //Confirm Password textfield
            MyTextField(
              hintText: "Confirm Password",
              obscureText: false,
              controller: confirmPwController,
            ),

            const SizedBox(height: 25),

            // Register
            MyButton(
              onTap: register,
              text: "Register",
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),

                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    " Login here",
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
