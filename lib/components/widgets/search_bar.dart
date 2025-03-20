
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final greyShade300 = Colors.grey.shade300;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.secondary)),
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
              color: greyShade300,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}