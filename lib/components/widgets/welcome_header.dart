
import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final String greeting;
  final String userName;


  const WelcomeHeader({
    super.key,
    required this.greeting,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final customBeige = const Color(0xFFb8b0a4);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, $userName!',
              style: TextStyle(
                color: customBeige,
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        // Logo
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Image.asset('assets/images/bidlogo.jpg'),
          ),
        )
      ],
    );
  }
}