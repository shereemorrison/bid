import 'package:flutter/foundation.dart';

abstract class BaseService {
  // Protected method for standardized error handling
  @protected
  Future<T> handleServiceOperation<T>(
      String operation,
      Future<T> Function() action, {
        required T defaultValue,
        bool throwError = false,
      }) async {
    try {
      return await action();
    } catch (e) {
      print('Service error $operation: $e');
      if (throwError) {
        rethrow;
      }
      return defaultValue;
    }
  }

  // Log service activity
  @protected
  void logServiceActivity(String activity, [String? details]) {
    final detailsText = details != null ? ' - $details' : '';
    print('${runtimeType.toString()}: $activity$detailsText');
  }
}
