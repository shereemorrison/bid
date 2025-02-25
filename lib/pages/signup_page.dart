import 'package:bid/components/my_drawer.dart';
import 'package:bid/components/my_navbar.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text('Sign Up'),
      ),
      //drawer: const MyDrawer(),
    );
  }
}
