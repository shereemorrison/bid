import 'package:flutter/material.dart';

// Format price with currency symbol
String formatPrice(double price, {String currency = '\$'}) {
  return '$currency${price.toStringAsFixed(2)}';
}

// Format date
String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

// Truncate text with ellipsis if it's too long
String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return '${text.substring(0, maxLength)}...';
}

// Format order ID
String formatOrderId(String orderId, {int displayLength = 8}) {
  return '#${orderId.substring(0, displayLength.clamp(1, orderId.length))}';
}

