import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to track the current checkout step
final checkoutStepProvider = StateProvider<int>((ref) => 0);

// Provider to track if checkout is complete
final checkoutCompleteProvider = StateProvider<bool>((ref) => false);
