
import 'package:bid/components/common_widgets/custom_textfield.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:bid/components/buttons/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage = "Incorrect email or password";

  @override
  void initState() {
    super.initState();
    _errorMessage = null;
  }

  Future<void> signIn() async {
    setState(() {
      _errorMessage = null;
    });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in all fields";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<SupabaseAuthProvider>(context, listen: false);
      await authProvider.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        if (authProvider.isLoggedIn) {
          userProvider.fetchUserData(authProvider.user!.id);
        }
        Navigator.of(context).pop();
        context.go('/account');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Incorrect email or password';
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
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Icon(
                Icons.person,
                size: 60,
                color: Theme.of(context).colorScheme.inversePrimary,
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
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              ),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? CircularProgressIndicator()
                  : GestureDetector(
                onTap: signIn,
                child: MyButton(
                  text: "Login",
                  onTap: signIn,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      " Register here",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

