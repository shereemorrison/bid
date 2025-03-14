
import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final String greeting;
  final String userName;
  final bool isDropdownOpen;
  final VoidCallback onToggleDropdown;

  const WelcomeHeader({
    super.key,
    required this.greeting,
    required this.userName,
    required this.isDropdownOpen,
    required this.onToggleDropdown,
  });

  @override
  Widget build(BuildContext context) {
    final customBeige = const Color(0xFFb8b0a4);
    final greyShade300 = Colors.grey.shade300;

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
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onToggleDropdown,
              child: Row(
                children: [
                  Text(
                    'CATEGORIES',
                    style: TextStyle(
                      color: greyShade300,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: greyShade300,
                    size: 18,
                  ),
                ],
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