import 'package:auto_route/auto_route.dart';
import 'package:bid/components/buttons/custom_button.dart';
import 'package:bid/components/widgets/custom_textfield.dart';
import 'package:bid/modals/loginmodal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/supabase_auth_provider.dart';
import '../routes/route.dart';

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

      if (mounted) {
        if (authProvider.isVerificationRequired && authProvider.user != null && authProvider.user!.emailConfirmedAt == null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: Text(
                  'Verify Your Email',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'We\'ve sent a verification email to $email. Please check your inbox and click the verification link to complete your registration.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        authProvider.resendConfirmationEmail(email);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Verification email resent')),
                        );
                      },
                      child: Text('Resend Verification Email'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          // Welcome dialog - First Name
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: Text(
                  'Welcome to B.I.D.${firstName.isNotEmpty ? ', $firstName' : ''}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                content: Text(
                  'You have successfully registered',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.surface),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      context.pushRoute(ProfileRoute());
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              );
            },
          );
        }
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
          padding: const EdgeInsets.all(20.0),
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
                        color: Theme.of(context).colorScheme.inversePrimary,
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
                          color: Theme.of(context).colorScheme.inversePrimary,
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