
import 'package:bid/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Opacity(
                  opacity: 0.8,
                  child: Image.asset(
                    'assets/images/bidlogo.jpg',
                    width: 200,
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 10
                ),

                //Title
                Text(
                  "WELCOME TO B.I.D.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 4.0,
                  ),

                    maxLines: 1,
                ),
                //Subtitle?
                Text(
                  "stefan časić",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
      
                  ),
                ),
                const SizedBox(height: 10),

                /*Text(
                  "ABOUT ME",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ),*/



              ]
          ),
        ),
          )
      )
      );
  }
}

