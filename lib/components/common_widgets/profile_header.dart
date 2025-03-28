
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.person,
          size: 60,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 30),
        Text(
          "BELIEVE IN DREAMS",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 4.0,
          ),
        ),
      ],
    );
  }
}