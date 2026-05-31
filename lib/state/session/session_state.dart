class SessionState {
  final bool isGuest;
  final String? guestUserId;
  final bool isCheckoutComplete;
  final String? orderConfirmationId;

  const SessionState({
    this.isGuest = true,
    this.guestUserId,
    this.isCheckoutComplete = false,
    this.orderConfirmationId,
  });

  SessionState copyWith({
    bool? isGuest,
    String? guestUserId,
    bool? isCheckoutComplete,
    String? orderConfirmationId,
  }) {
    return SessionState(
      isGuest: isGuest ?? this.isGuest,
      guestUserId: guestUserId ?? this.guestUserId,
      isCheckoutComplete: isCheckoutComplete ?? this.isCheckoutComplete,
      orderConfirmationId: orderConfirmationId ?? this.orderConfirmationId,
    );
  }
}
