import 'package:bid/components/my_button.dart';
import 'package:bid/components/my_drawer.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
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
              MyButton(
                onTap: () => Navigator.pushNamed(context, '/shop_page'),
                child: Icon(
                    Icons.arrow_circle_right_outlined,
                    size: 40,
                    color: Colors.grey[800]
                ),
              )
            ]
        ),
      ),
    );
  }
}

