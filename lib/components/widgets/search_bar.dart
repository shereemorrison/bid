
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final greyShade300 = Colors.grey.shade300;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Icon(
            Icons.search,
            color: greyShade300,
          ),
          const SizedBox(width: 10),
          Text(
            'Search',
            style: TextStyle(
              color: greyShade300.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}