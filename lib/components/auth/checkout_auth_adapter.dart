import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assume these providers and widgets are defined elsewhere in your project
// For example:
// import 'package:your_app/providers/checkout_provider.dart';
// import 'package:your_app/widgets/create_account_from_guest_form.dart';

enum CheckoutAuthState {
  initial,
  guest,
  createAccount,
  completed,
}

final checkoutAuthStateProvider = StateProvider<CheckoutAuthState>((ref) => CheckoutAuthState.initial);

class CheckoutAuthAdapter extends ConsumerStatefulWidget {
  const CheckoutAuthAdapter({
    Key? key,
    required this.onAuthSuccess,
    required this.onContinueAsGuest,
  }) : super(key: key);

  final VoidCallback onAuthSuccess;
  final VoidCallback onContinueAsGuest;

  @override
  ConsumerState<CheckoutAuthAdapter> createState() => _CheckoutAuthAdapterState();
}

class _CheckoutAuthAdapterState extends ConsumerState<CheckoutAuthAdapter> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(checkoutAuthStateProvider);

    switch (authState) {
      case CheckoutAuthState.initial:
        return _buildInitialState();
      case CheckoutAuthState.guest:
        return _buildGuestCheckout();
      case CheckoutAuthState.createAccount:
        return _buildCreateAccountFromGuest();
      case CheckoutAuthState.completed:
        return const Center(child: Text('Checkout Completed!')); // Replace with actual completion UI
    }
  }

  Widget _buildInitialState() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.createAccount;
          },
          child: const Text('Create Account & Checkout'),
        ),
        TextButton(
          onPressed: () {
            ref.read(checkoutAuthStateProvider.notifier).state = CheckoutAuthState.guest;
            widget.onContinueAsGuest();
          },
          child: const Text('Continue as Guest'),
        ),
      ],
    );
  }

  Widget _buildGuestCheckout() {
    return const Center(child: Text('Guest Checkout Form Here')); // Replace with actual guest checkout form
  }

  Widget _buildCreateAccountFromGuest() {
    // Get the current checkout session
    final checkoutState = ref.read(checkoutProvider);

    // Pre-fill form with data from checkout session
    final shippingAddress = checkoutState.shippingAddress ?? {};
    String firstName = '';
    String lastName = '';
    String email = '';

    if (shippingAddress is Map) {
      firstName = shippingAddress['firstName'] ?? '';
      lastName = shippingAddress['lastName'] ?? '';
      email = shippingAddress['email'] ?? '';
    } else if (shippingAddress != null) {
      firstName = shippingAddress.firstName ?? '';
      lastName = shippingAddress.lastName ?? '';
      email = shippingAddress.email ?? '';
    }

    return CreateAccountFromGuestForm(
      initialFirstName: firstName,
      initialLastName: lastName,
      initialEmail: email,
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

// Dummy implementations for dependencies
final checkoutProvider = Provider((ref) => CheckoutState());

class CheckoutState {
  dynamic shippingAddress;
}

class CreateAccountFromGuestForm extends StatelessWidget {
  const CreateAccountFromGuestForm({
    Key? key,
    required this.initialFirstName,
    required this.initialLastName,
    required this.initialEmail,
    required this.onAccountCreated,
    required this.onCancel,
  }) : super(key: key);

  final String initialFirstName;
  final String initialLastName;
  final String initialEmail;
  final VoidCallback onAccountCreated;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Placeholder(); // Replace with actual form
  }
}
