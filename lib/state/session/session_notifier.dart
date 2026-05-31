import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'session_state.dart';

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  void setGuestUserId(String userId) {
    state = state.copyWith(guestUserId: userId, isGuest: true);
  }

  void clearGuestState() {
    state = const SessionState();
  }

  void setCheckoutComplete(String orderId) {
    state = state.copyWith(
      isCheckoutComplete: true,
      orderConfirmationId: orderId,
    );
  }

  void resetCheckout() {
    state = state.copyWith(
      isCheckoutComplete: false,
      orderConfirmationId: null,
    );
  }
}
