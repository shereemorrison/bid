
import 'package:bid/components/my_button.dart';
import 'package:bid/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatelessWidget {
  final void Function()? onTap;

  RegistrationPage({super.key, required this.onTap});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(BuildContext context) async {
    // Validate the form fields (email and password)
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPwController.text.trim();

    // Check fields complete
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      print("Please fill in all fields.");
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      // Show an error message if passwords don't match
      print("Passwords do not match.");
      return;
    }

    try {
      // Register the user with Firebase
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("User registered: ${userCredential.user?.email}");

      // Show welcome dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text('Welcome to B.I.D.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
            content: Text('You have succesfully registered',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.surface),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate to the profile page after the user clicks "OK"
                  Navigator.pushReplacementNamed(context, '/profile_page');  // Change '/profile' to the actual route
                },
                child: Text('OK',
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          );
        },
      );


    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      // Handle any other errors
      print('Error: $e');

  }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary, // Outline color
            width: 2,
          )
        ),
        child: Container(
          width: 600,
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sign Up",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary)
                ),
                Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).colorScheme.secondary,
                ),

                const SizedBox(height: 25),

                Text(
                  "B E L I E V E  I N  D R E A M S",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                const SizedBox(height: 40),

                MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  hintText: "Enter Password",
                  obscureText: false,
                  controller: passwordController,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: false,
                  controller: confirmPwController,
                ),

                const SizedBox(height: 25),
                MyButton(
                  onTap: () => register(context),
                  text: "Register",
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 12,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        " Login here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}

