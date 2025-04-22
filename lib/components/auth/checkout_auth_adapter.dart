import 'package:bid/components/auth/checkout_auth_options.dart';
import 'package:bid/components/auth/login_form.dart';
import 'package:bid/components/auth/register_form.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CheckoutAuthAdapter extends ConsumerStatefulWidget {
  final VoidCallback onAuthSuccess;
  final VoidCallback onContinueAsGuest;
  final VoidCallback? onCancel;

  const CheckoutAuthAdapter({
    Key? key,
    required this.onAuthSuccess,
    required this.onContinueAsGuest,
    this.onCancel,
  }) : super(key: key);

  @override
  ConsumerState<CheckoutAuthAdapter> createState() => _CheckoutAuthAdapterState();
}

class _CheckoutAuthAdapterState extends ConsumerState<CheckoutAuthAdapter> {
  bool _showAuthOptions = true;
  bool _showLoginForm = false;
  bool _showRegisterForm = false;

  void _handleAuthOptionSelected(CheckoutAuthOption option) {
    switch (option) {
      case CheckoutAuthOption.login:
        setState(() {
          _showAuthOptions = false;
          _showLoginForm = true;
          _showRegisterForm = false;
        });
        break;
      case CheckoutAuthOption.register:
        setState(() {
          _showAuthOptions = false;
          _showLoginForm = false;
          _showRegisterForm = true;
        });
        break;
      case CheckoutAuthOption.guest:
      // Proceed as guest
        widget.onContinueAsGuest();
        break;
    }
  }

  void _handleLoginSuccess() {
    widget.onAuthSuccess();
  }

  void _handleRegisterSuccess() {
    widget.onAuthSuccess();
  }

  void _switchToLogin() {
    setState(() {
      _showAuthOptions = false;
      _showLoginForm = true;
      _showRegisterForm = false;
    });
  }

  void _switchToRegister() {
    setState(() {
      _showAuthOptions = false;
      _showLoginForm = false;
      _showRegisterForm = true;
    });
  }

  void _backToOptions() {
    setState(() {
      _showAuthOptions = true;
      _showLoginForm = false;
      _showRegisterForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in after auth operations
    final isLoggedIn = ref.watch(isLoggedInProvider);

    // If user is logged in, call onAuthSuccess
    if (isLoggedIn) {
      // Use a post-frame callback to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onAuthSuccess();
      });
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_showAuthOptions)
                  CheckoutAuthOptions(
                    onOptionSelected: _handleAuthOptionSelected,
                    showCloseButton: widget.onCancel != null,
                    onClose: widget.onCancel,
                  ),

                if (_showLoginForm)
                  LoginForm(
                    onLoginSuccess: _handleLoginSuccess,
                    onCancel: _backToOptions,
                    onRegisterInstead: _switchToRegister,
                    showBackButton: true,
                  ),

                if (_showRegisterForm)
                  RegisterForm(
                    onRegisterSuccess: _handleRegisterSuccess,
                    onCancel: _backToOptions,
                    onLoginInstead: _switchToLogin,
                    showBackButton: true,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
