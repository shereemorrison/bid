
import 'package:bid/themes/dark_mode.dart';
import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final List<String> categories;

  const CategoryDropdown({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final greyShade300 = Colors.grey.shade300;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.quinary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            category,
            style: TextStyle(
              color: greyShade300,
              fontSize: 16,
            ),
          ),
        )).toList(),
      ),
    );
  }
}