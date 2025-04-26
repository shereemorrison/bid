
import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';

class OurStorySection extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description1;
  final String description2;
  final VoidCallback onReadMorePressed;

  const OurStorySection({
    Key? key,
    required this.imageUrl,
    this.title = "SPORT NEVER SLEEPS",
    this.description1 = "Our latest collection is inspired by the rhythm of sporting life. Designed for those who move through life with purpose, our pieces blend functionality with a distinct aesthetic that stands out in any environment.",
    this.description2 = "From premium leather sports bags, to essential wardrobe staples, each item is crafted to accompany you on your journey, no matter your goal.",
    required this.onReadMorePressed,
  }) : super(key: key);

  // TODO - work out where to put this text, probably shouldn't be hard coded in
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "OUR STORY",
            style: TextStyle(
              color: Theme.of(context).colorScheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description1,
            style: TextStyle(
              color: Theme.of(context).colorScheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description2,
            style: TextStyle(
              color: Theme.of(context).colorScheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          /*OutlinedButton(
            onPressed: onReadMorePressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text(
              "READ MORE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}

