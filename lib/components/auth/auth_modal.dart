import 'package:flutter/material.dart';
import 'login_form.dart';
import 'register_form.dart';

enum AuthModalType {
  login,
  register
}

class AuthModal extends StatefulWidget {
  final AuthModalType initialType;
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onRegisterSuccess;
  final VoidCallback? onCancel;

  const AuthModal({
    Key? key,
    this.initialType = AuthModalType.login,
    this.onLoginSuccess,
    this.onRegisterSuccess,
    this.onCancel,
  }) : super(key: key);

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  late AuthModalType _currentType;

  @override
  void initState() {
    super.initState();
    _currentType = widget.initialType;
  }

  void _switchToLogin() {
    setState(() {
      _currentType = AuthModalType.login;
    });
  }

  void _switchToRegister() {
    setState(() {
      _currentType = AuthModalType.register;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: _currentType == AuthModalType.login
          ? LoginForm(
        onLoginSuccess: widget.onLoginSuccess,
        onCancel: widget.onCancel,
        onRegisterInstead: _switchToRegister,
      )
          : RegisterForm(
        onRegisterSuccess: widget.onRegisterSuccess,
        onCancel: widget.onCancel,
        onLoginInstead: _switchToLogin,
      ),
    );
  }
}
