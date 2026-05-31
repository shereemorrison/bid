import 'package:bid/components/address_widgets/address_form.dart';
import 'package:bid/components/checkout/simple_payment_form.dart';
import 'package:bid/components/order_widgets/order_summary.dart';
import 'package:bid/models/address_model.dart';
import 'package:bid/models/user_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/utils/order_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' show CardFieldInputDetails;
import 'package:go_router/go_router.dart';

class SimpleCheckoutPage extends ConsumerStatefulWidget {
  const SimpleCheckoutPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SimpleCheckoutPage> createState() => _SimpleCheckoutPageState();
}

class _SimpleCheckoutPageState extends ConsumerState<SimpleCheckoutPage> {
  int _currentStep = 0;
  Address? _shippingAddress;
  bool _isProcessing = false;
  List<Address> _userAddresses = [];
  bool _loadingAddresses = false;
  bool _addressSyncStarted = false;
  final _cardHolderNameController = TextEditingController();
  CardFieldInputDetails? _cardDetails;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncShippingAddress();
    });
  }

  @override
  void dispose() {
    _cardHolderNameController.dispose();
    super.dispose();
  }

  void _clearShippingState() {
    if (!mounted) return;
    setState(() {
      _shippingAddress = null;
      _userAddresses = [];
      _loadingAddresses = false;
      _addressSyncStarted = false;
      _currentStep = 0;
      _cardDetails = null;
    });
    _cardHolderNameController.clear();
  }

  void _applyAddresses(List<Address> addresses) {
    if (!mounted || addresses.isEmpty) return;

    setState(() {
      _userAddresses = addresses;
      _loadingAddresses = false;
      _shippingAddress = addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => addresses.first,
      );
    });
  }

  Future<void> _syncShippingAddress() async {
    if (_addressSyncStarted) return;
    _addressSyncStarted = true;

    final isLoggedIn = ref.read(isLoggedInProvider);
    if (!isLoggedIn) {
      _addressSyncStarted = false;
      return;
    }

    await ref.read(authProvider.notifier).refreshUserData();
    var userData = ref.read(userDataProvider);

    if (userData == null) {
      if (mounted) setState(() => _loadingAddresses = false);
      _addressSyncStarted = false;
      return;
    }

    if (userData.addresses.isNotEmpty) {
      _applyAddresses(userData.addresses);
    } else {
      final userRepository = ref.read(userRepositoryProvider);
      final addresses = await userRepository.resolveUserAddresses(userData);
      if (addresses.isNotEmpty) {
        _applyAddresses(addresses);
      } else {
        await _loadUserAddresses(userData.userId);
      }
    }

    if (mounted && _cardHolderNameController.text.isEmpty) {
      _cardHolderNameController.text = userData.fullName;
    }
  }

  Future<void> _loadUserAddresses(String userId) async {
    setState(() => _loadingAddresses = true);
    try {
      final userRepository = ref.read(userRepositoryProvider);
      final userData = ref.read(userDataProvider);
      if (userData != null) {
        final addresses = await userRepository.resolveUserAddresses(userData);
        if (mounted && addresses.isNotEmpty) {
          _applyAddresses(addresses);
          return;
        }
      }

      final addressRepository = ref.read(addressRepositoryProvider);
      final addresses = await addressRepository.getUserAddresses(userId);
      if (mounted && addresses.isNotEmpty) {
        _applyAddresses(addresses);
      } else if (mounted) {
        setState(() => _loadingAddresses = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingAddresses = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(isLoggedInProvider, (previous, next) {
      if (previous == true && next == false) {
        _clearShippingState();
      } else if (previous == false && next == true) {
        _addressSyncStarted = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _syncShippingAddress();
        });
      }
    });

    ref.listen<UserData?>(userDataProvider, (previous, next) {
      if (next == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (next.addresses.isNotEmpty) {
          _applyAddresses(next.addresses);
        } else if (ref.read(isLoggedInProvider)) {
          _loadUserAddresses(next.userId);
        }
        if (_cardHolderNameController.text.isEmpty) {
          _cardHolderNameController.text = next.fullName;
        }
      });
    });

    final cartItems = ref.watch(cartItemsProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(
          child: Text('Your cart is empty'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout - Step ${_currentStep + 1} of 3'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Shipping'),
                Expanded(child: _buildStepLine(0)),
                _buildStepIndicator(1, 'Payment'),
                Expanded(child: _buildStepLine(1)),
                _buildStepIndicator(2, 'Review'),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: _buildStepContent(cartItems, isLoggedIn, colorScheme),
          ),
          
          // Bottom navigation
          if (_currentStep <= 2)
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canProceed() ? _proceedToNextStep : null,
                  child: Text(_getNextButtonText()),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;
    
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive || isCompleted 
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '${step + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive || isCompleted 
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isCompleted = _currentStep > step;
    return Container(
      height: 2,
      color: isCompleted 
          ? Theme.of(context).colorScheme.primary
          : Colors.grey,
    );
  }

  Widget _buildStepContent(List<dynamic> cartItems, bool isLoggedIn, ColorScheme colorScheme) {
    switch (_currentStep) {
      case 0:
        return _buildShippingStep(cartItems, isLoggedIn);
      case 1:
        return _buildPaymentStep(cartItems);
      case 2:
        return _buildReviewStep(cartItems);
      default:
        return const Center(child: Text('Invalid step'));
    }
  }

  Widget _buildAddressCard(Address address) {
    final isSelected = _shippingAddress?.id == address.id;
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () {
          setState(() {
            _shippingAddress = address;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<Address>(
                value: address,
                groupValue: _shippingAddress,
                onChanged: (value) {
                  setState(() {
                    _shippingAddress = value;
                  });
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${address.firstName} ${address.lastName}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(address.streetAddress),
                    if (address.apartment != null && address.apartment!.isNotEmpty)
                      Text(address.apartment!),
                    Text('${address.city}, ${address.state} ${address.postalCode}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingStep(List<dynamic> cartItems, bool isLoggedIn) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Show existing addresses for logged in users
          if (isLoggedIn && _loadingAddresses)
            const Center(child: CircularProgressIndicator()),
          if (isLoggedIn && !_loadingAddresses && _userAddresses.isNotEmpty) ...[
            Text(
              'Select Address',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._userAddresses.map((address) => _buildAddressCard(address)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Or Add New Address',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
          ],
          
          if (_shippingAddress != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_shippingAddress!.firstName} ${_shippingAddress!.lastName}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(_shippingAddress!.streetAddress),
                    if (_shippingAddress!.apartment != null && _shippingAddress!.apartment!.isNotEmpty)
                      Text(_shippingAddress!.apartment!),
                    Text('${_shippingAddress!.city}, ${_shippingAddress!.state} ${_shippingAddress!.postalCode}'),
                    Text(_shippingAddress!.country),
                    const SizedBox(height: 8),
                    Text('Phone: ${_shippingAddress!.phone}'),
                    Text('Email: ${_shippingAddress!.email}'),
                  ],
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.location_on, size: 48, color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text('No shipping address selected'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _addShippingAddress(),
                      child: const Text('Add Shipping Address'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep(List<dynamic> cartItems) {
    return SimplePaymentForm(
      cardHolderNameController: _cardHolderNameController,
      onCardChanged: (details) => setState(() => _cardDetails = details),
    );
  }

  Widget _buildReviewStep(List<dynamic> cartItems) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Your Order',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          
          // Order summary
          OrderSummary(
            totalAmount: cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)),
            onCheckout: () {}, // Not used in this context
          ),
          
          const SizedBox(height: 16),
          
          // Shipping address review
          if (_shippingAddress != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping Address',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('${_shippingAddress!.firstName} ${_shippingAddress!.lastName}'),
                    Text(_shippingAddress!.streetAddress),
                    if (_shippingAddress!.apartment != null && _shippingAddress!.apartment!.isNotEmpty)
                      Text(_shippingAddress!.apartment!),
                    Text('${_shippingAddress!.city}, ${_shippingAddress!.state} ${_shippingAddress!.postalCode}'),
                    Text(_shippingAddress!.country),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    switch (_currentStep) {
      case 0:
        return 'Continue to Payment';
      case 1:
        return 'Review Order';
      case 2:
        return 'Place Order';
      default:
        return 'Continue';
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _shippingAddress != null;
      case 1:
        return _cardDetails?.complete == true &&
            _cardHolderNameController.text.trim().isNotEmpty;
      case 2:
        return true;
      default:
        return false;
    }
  }

  Future<void> _proceedToNextStep() async {
    if (_currentStep < 2) {
      // Prevent flutter_stripe KeepVisibleOnFocus crash when CardField unmounts.
      if (_currentStep == 1) {
        FocusManager.instance.primaryFocus?.unfocus();
        await Future<void>.delayed(const Duration(milliseconds: 120));
      }
      if (!mounted) return;
      setState(() {
        _currentStep++;
      });
    } else {
      _placeOrder();
    }
  }

  void _addShippingAddress() async {
    final address = await Navigator.of(context).push<Address>(
      MaterialPageRoute(
        builder: (context) => AddressForm(
          onSave: (_) {},
        ),
      ),
    );

    if (address != null) {
      setState(() {
        _shippingAddress = address;
      });
      // Reload addresses for logged in users
      await _loadUserAddresses(_shippingAddress!.userId);
    }
  }

  void _placeOrder() async {
    if (_isProcessing || _shippingAddress == null) return;

    if (_cardDetails == null || !_cardDetails!.complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid card details')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final cartItems = ref.read(cartItemsProvider);
      final subtotal = OrderCalculator.calculateProductSubtotal(
        cartItems.map((item) => item.product).toList(),
      );
      const shipping = 10.0;
      final tax = OrderCalculator.calculateTax(subtotal);
      final total = OrderCalculator.calculateTotal(
        subtotal: subtotal,
        taxAmount: tax,
        shippingAmount: shipping,
        discountAmount: 0,
      );

      final paymentService = ref.read(paymentServiceProvider);
      final result = await paymentService.processPayment(
        cardHolderName: _cardHolderNameController.text.trim(),
        cardDetails: _cardDetails!,
        amount: total,
        shippingAddress: _shippingAddress!,
      );

      if (result['success'] != true) {
        throw Exception(result['error'] ?? 'Payment failed');
      }

      final orderId = result['orderId'] as String?;
      ref.read(cartProvider.notifier).clearCart();
      resetCheckoutStateFromWidget(ref);
      if (orderId != null) {
        ref.read(sessionProvider.notifier).setCheckoutComplete(orderId);
      }

      if (mounted) {
        final path = orderId != null
            ? '/order-confirmation?order_id=$orderId'
            : '/order-confirmation';
        context.go(path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
