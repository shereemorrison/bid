
import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final String imageUrl;
//  final String greeting;
  final String userName;
  final VoidCallback onShopNowPressed;

  const HeroSection({
    Key? key,
    required this.imageUrl,
    //required this.greeting,
    required this.userName,
    required this.onShopNowPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    //Fixed colors so they display the same on the image
    const Color titleColor = Colors.white;
    const Color descriptionColor = Color(0xDDFFFFFF);
    const Color buttonTextColor = Colors.white;
    const Color buttonBorderColor = Colors.white;

    return Stack(
      children: [
        // Background Image
        Container(
          height: 500,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.darken,
              ),
            ),
          ),
        ),

        // Content Overlay
        /*Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: WelcomeHeader(
            //greeting: greeting,
            userName: userName,
          ),
        ),*/

        // Bottom Content
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "THE BID JOURNEY",
                style: textTheme.titleLarge?.copyWith
                  (
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "Discover our new collection",
                style: textTheme.bodyLarge?.copyWith(
                  color: descriptionColor, // Using opacity instead of Colors.white70
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: onShopNowPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: buttonBorderColor),
                    borderRadius: BorderRadius.circular(0),
                  ),
                child: const Text(
                  "SHOP NOW",
                  style: TextStyle(
                    color: buttonTextColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}