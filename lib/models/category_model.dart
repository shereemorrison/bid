
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String? subtitle;
  final String? route;
  final IconData? icon;
  final String? imageUrl;
  final String? imageAsset;
  final Scrollable;

  Category({
    required this.id,
    required this.name,
    this.route,
    this.subtitle = '',
    this.icon,
    this.imageUrl,
    this.imageAsset,
    this.Scrollable,
  });

  // Factory method to create a Category from Firebase data
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      route: map['route'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }
}