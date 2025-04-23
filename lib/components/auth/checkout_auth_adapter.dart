import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/checkout_auth_state.dart';
import '../../services/auth_service.dart';
import '../../services/checkout_session_manager.dart';
import 'checkout_auth_options.dart';
import 'checkout_login_view.dart';
import 'checkout_register_view.dart';
import 'create_account_from_guest_form.dart';

class CheckoutAuthAdapter extends ConsumerStatefulWidget {
  final VoidCallback onAuthSuccess;
  final VoidCallback onContinueAsGuest;
  final VoidCallback? onCancel;

  const CheckoutAuthAdapter({
    Key? key,
    required this.onAuthSuccess,
    required this.onContinueAsGuest,
    this.onCancel,
  }) : super(key: key);

  @override
  ConsumerState<CheckoutAuthAdapter> createState() => _CheckoutAuthAdapterState();
}

class _CheckoutAuthAdapterState extends ConsumerState<CheckoutAuthAdapter> {
  @override
  void initState() {
    super.initState();
    // Reset the auth state when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.options;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current auth state
    final authState = ref.watch(checkoutAuthStateProvider);

    // Get the auth service
    final authService = ref.watch(authServiceProvider);

    // Check if user is logged in - using the centralized auth service
    final isLoggedIn = ref.watch(authService.isLoggedInProvider);

    // If user is logged in, call onAuthSuccess
    if (isLoggedIn) {
      // Use a post-frame callback to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onAuthSuccess();
      });
    }

    return WillPopScope(
      // Prevent accidental back navigation
      onWillPop: () async {
        if (authState != CheckoutAuthState.options && widget.onCancel != null) {
          ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.options;
          return false;
        }
        return true;
      },
      child: Container(
        color: Colors.black,
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: _buildCurrentView(authState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView(CheckoutAuthState state) {
    switch (state) {
      case CheckoutAuthState.options:
        return _buildAuthOptions();
      case CheckoutAuthState.login:
        return _buildLoginView();
      case CheckoutAuthState.register:
        return _buildRegisterView();
      case CheckoutAuthState.createAccountFromGuest:
        return _buildCreateAccountFromGuest();
      case CheckoutAuthState.guestCheckout:
      // Handle in parent widget
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onContinueAsGuest();
        });
        return const Center(child: CircularProgressIndicator());
      case CheckoutAuthState.completed:
      // Handle in parent widget
        return const SizedBox.shrink();
    }
  }

  Widget _buildAuthOptions() {
    return CheckoutAuthOptions(
      onOptionSelected: (option) {
        switch (option) {
          case CheckoutAuthOption.login:
            ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.login;
            break;
          case CheckoutAuthOption.register:
            ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.register;
            break;
          case CheckoutAuthOption.guest:
            ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.guestCheckout;
            break;
        }
      },
      showCloseButton: widget.onCancel != null,
      onClose: widget.onCancel,
    );
  }

  Widget _buildLoginView() {
    return CheckoutLoginView(
      onLoginSuccess: () {
        ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.completed;
        widget.onAuthSuccess();
      },
      onBackToOptions: () {
        ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.options;
      },
    );
  }

  Widget _buildRegisterView() {
    return CheckoutRegisterView(
      onRegisterSuccess: () {
        ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.completed;
        widget.onAuthSuccess();
      },
      onBackToOptions: () {
        ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.options;
      },
    );
  }

  Widget _buildCreateAccountFromGuest() {
    // Get the current checkout session
    final sessionManager = ref.read(checkoutSessionManagerProvider);
    final sessionData = sessionManager.getCurrentSession();

    // Pre-fill form with data from checkout session
    final shippingAddress = sessionData?.shippingAddress ?? {};

    return CreateAccountFromGuestForm(
      initialFirstName: shippingAddress['firstName'] ?? '',
      initialLastName: shippingAddress['lastName'] ?? '',
      initialEmail: shippingAddress['email'] ?? '',
      onAccountCreated: () {
        ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.completed;
        widget.onAuthSuccess();
      },
      onCancel: () {
        // Go back to guest checkout
        widget.onContinueAsGuest();
      },
    );
  }
}
