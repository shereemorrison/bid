import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/supabase_auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../components/common_widgets/custom_textfield.dart';
import '../../components/buttons/custom_button.dart';

class LoginForm extends ConsumerStatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onCancel;
  final VoidCallback? onRegisterInstead;
  final bool showBackButton;

  const LoginForm({
    Key? key,
    this.onLoginSuccess,
    this.onCancel,
    this.onRegisterInstead,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        final isLoggedIn = ref.read(isLoggedInProvider);
        final authUserId = ref.read(authUserIdProvider);

        if (isLoggedIn && authUserId != null) {
          ref.read(userNotifierProvider.notifier).updateUserData(authUserId);
        }

        if (widget.onLoginSuccess != null) {
          widget.onLoginSuccess!();
        } else {
          Navigator.of(context).pop();
        }
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: BoxConstraints(
        maxWidth: 600,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.showBackButton && widget.onCancel != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: widget.onCancel,
                    ),
                  ),

                Text(
                  "Login",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
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

                // Email field with validation
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Password field with validation
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
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
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                _isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                  text: "Login",
                  onTap: signIn,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onRegisterInstead,
                      child: Text(
                        "Register here",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 12,
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
      ),
    );
  }
}
