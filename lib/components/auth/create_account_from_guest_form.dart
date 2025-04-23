import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/guest_to_registered_converter.dart';
import '../common_widgets/custom_textfield.dart';
import '../buttons/custom_button.dart';

/// A specialized form for converting guest users to registered users
///
/// This form:
/// - Pre-fills data from the guest checkout
/// - Creates an account without losing checkout progress
/// - Provides a streamlined experience for guest-to-registered conversion
class CreateAccountFromGuestForm extends ConsumerStatefulWidget {
  final String initialFirstName;
  final String initialLastName;
  final String initialEmail;
  final VoidCallback onAccountCreated;
  final VoidCallback onCancel;

  const CreateAccountFromGuestForm({
    Key? key,
    required this.initialFirstName,
    required this.initialLastName,
    required this.initialEmail,
    required this.onAccountCreated,
    required this.onCancel,
  }) : super(key: key);

  @override
  ConsumerState<CreateAccountFromGuestForm> createState() =>
      _CreateAccountFromGuestFormState();
}

class _CreateAccountFromGuestFormState extends
ConsumerState<CreateAccountFromGuestForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _subscribeToNewsletter = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with pre-filled data
    firstNameController = TextEditingController(text: widget.initialFirstName);
    lastNameController = TextEditingController(text: widget.initialLastName);
    emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      // Get the guest to registered converter
      final converter = ref.read(guestToRegisteredConverterProvider);

      // Convert guest to registered user
      final success = await converter.convertGuestToRegistered(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
      );

      if (!success) {
        throw Exception("Failed to create account");
      }

      if (mounted) {
        widget.onAccountCreated();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error creating account: ${e.toString()}";
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
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onCancel,
                  ),
                ),

                Text(
                  "Create Your Account",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Complete your purchase and save your information for next time",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 30),

                // Form fields (similar to RegisterForm but pre-filled)
                // First name and last name
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        hintText: "First Name",
                        obscureText: false,
                        controller: firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextField(
                        hintText: "Last Name",
                        obscureText: false,
                        controller: lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Email
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

                // Password
                MyTextField(
                  hintText: "Create Password",
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // Confirm password
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPwController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
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

                // Create account button
                _isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                  onTap: createAccount,
                  text: "Create Account & Continue",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
