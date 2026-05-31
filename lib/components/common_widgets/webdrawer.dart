//drawer widget that can be used in both web and mobile layouts
import 'package:flutter/material.dart';

class Webdrawer extends StatelessWidget {
  final Widget child;

  const Webdrawer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header section
            DrawerHeader(
              child: Row(
                children: [
                  Icon(Icons.menu, size: 32),
                  const SizedBox(width: 16),
                  Text('Menu', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            // Main content
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
