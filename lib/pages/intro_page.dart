import 'package:bid/components/my_button.dart';
import 'package:bid/components/my_drawer.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Intro"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(125),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 80,
                  height: 80,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //Title
              Text(
                "Believe in Dreams",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey[800],

                ),
              ),
              //Subtitle?
              Text(
                "Stefan Časić",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[800],

                ),
              ),
              const SizedBox(height: 10),

            ]
        ),
      ),
    )
    );
  }
}

