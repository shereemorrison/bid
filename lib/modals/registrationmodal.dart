
import 'package:bid/components/buttons/custom_button.dart';
import 'package:bid/components/common_widgets/custom_textfield.dart';
import 'package:bid/modals/loginmodal.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/services/newsletter_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  final void Function()? onTap;

  const RegistrationPage({super.key, required this.onTap});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _subscribeToNewsletter = false; // Add state for newsletter subscription
  final NewsletterService _newsletterService = NewsletterService(); // Initialize newsletter service

  @override
  void initState() {
    super.initState();
    _errorMessage = null;
  }

  Future<void> register() async {
    setState(() {
      _errorMessage = null;
    });

    // Validate the form fields
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPwController.text.trim();
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();

    // Check required fields complete
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords don\'t match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Register the user with Supabase
      final authProvider = Provider.of<SupabaseAuthProvider>(context, listen: false);
      await authProvider.signUp(
        email,
        password,
        firstName: firstName,
        lastName: lastName,
      );

      if (_subscribeToNewsletter) {
        try {
          // Get user ID if available
          String? userId = authProvider.user?.id;

          // Subscribe to newsletter
          await _newsletterService.subscribeToNewsletter(
            email,
            userId: userId,
          );
        } catch (e) {
          // Don't block registration if newsletter subscription fails
          print('Newsletter subscription failed: ${e.toString()}');
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                  width: 2,
                ),
              ),
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              title: Text(
                'Welcome to B.I.D.${firstName.isNotEmpty
                    ? ', $firstName'
                    : ''}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary),
              ),
              content: Text(
                'You have successfully registered',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme
                    .of(context)
                    .colorScheme
                    .surface),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    context.go('/account');
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error registering: ${e.toString()}";
          _isLoading = false;
        });
      }
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
        ),
      ),
      child: SizedBox(
        width: 600,
        height: 650,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).colorScheme.onSurface,
                ),

                const SizedBox(height: 25),

                Text(
                  "BELIEVE  IN  DREAMS",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        hintText: "First Name",
                        obscureText: false,
                        controller: firstNameController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextField(
                        hintText: "Last Name",
                        obscureText: false,
                        controller: lastNameController,
                      ),
                    ),
                  ],
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
                  obscureText: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwController,
                ),

                // Newsletter subscription checkbox
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _subscribeToNewsletter,
                          onChanged: (value) {
                            setState(() {
                              _subscribeToNewsletter = value ?? false;
                            });
                          },
                          activeColor: Theme.of(context).colorScheme.secondary,
                          checkColor: Theme.of(context).colorScheme.surface,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Subscribe to our newsletter for exclusive offers and updates",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),

                const SizedBox(height: 25),

                _isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
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
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LoginPage(
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return LoginPage(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        " Login here",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
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
        ),
      ),
    );
  }
}