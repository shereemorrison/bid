import 'package:bid/core/providers/session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void resetCheckoutState(Ref ref) {
  ref.read(sessionProvider.notifier).resetCheckout();
}

void resetCheckoutStateFromWidget(WidgetRef ref) {
  ref.read(sessionProvider.notifier).resetCheckout();
}
