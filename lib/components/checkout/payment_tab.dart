import 'package:bid/utils/payment_service_helper.dart';
import 'package:bid/utils/payment_tab_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/checkout_provider.dart';
import '../../providers/payment_provider.dart';
import '../../utils/format_helpers.dart';
import '../../services/database_diagnostic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentTab extends ConsumerStatefulWidget {
  final double amount;
  final VoidCallback onBack;

  const PaymentTab({
    Key? key,
    required this.amount,
    required this.onBack,
  }) : super(key: key);

  @override
  ConsumerState<PaymentTab> createState() => _PaymentTabState();
}

class _PaymentTabState extends ConsumerState<PaymentTab> with AutomaticKeepAliveClientMixin {
  int _selectedPaymentMethod = 0; // 0 = Credit Card, 1 = Add New, 2 = Cash
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  @override
  bool get wantKeepAlive => true; // Keep the state alive when switching tabs

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  void _setErrorMessage(String? errorMessage) {
    if (mounted) {
      setState(() {
        _errorMessage = errorMessage;
      });
    }
  }

  void _handlePaymentMethodChanged(int method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Future<void> _handlePayment(BuildContext context) async {
    await PaymentServiceHelper.processPayment(
      context: context,
      ref: ref,
      selectedPaymentMethod: _selectedPaymentMethod,
      name: _nameController.text,
      cardNumber: _cardNumberController.text,
      expiry: _expiryController.text,
      cvc: _cvcController.text,
      setLoading: _setLoading,
      setErrorMessage: _setErrorMessage,
    );
  }

  Future<void> _runDiagnostic() async {
    setState(() {
      _isLoading = true;
      _errorMessage = 'Running database diagnostic...';
    });

    try {
      final diagnostic = DatabaseDiagnostic(Supabase.instance.client);
      await diagnostic.runDiagnostic();

      setState(() {
        _errorMessage = 'Diagnostic complete. Check console logs.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Diagnostic error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Main content - scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Method
                Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Payment options
                PaymentTabUIHelper.buildPaymentMethodOptions(
                  context: context,
                  selectedPaymentMethod: _selectedPaymentMethod,
                  onPaymentMethodChanged: _handlePaymentMethodChanged,
                ),

                const SizedBox(height: 24),

                // Payment details title
                Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 16),

                // Card input fields
                PaymentTabUIHelper.buildCardInputFields(
                  context: context,
                  nameController: _nameController,
                  cardNumberController: _cardNumberController,
                  expiryController: _expiryController,
                  cvcController: _cvcController,
                ),

                const SizedBox(height: 16),

                // Error message (if any)
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Security note
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Payments are secure and encrypted',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: TextButton(
              onPressed: _runDiagnostic,
              child: const Text('Run Database Diagnostic'),
            ),
          ),
        ),

        // Bottom buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: PaymentTabUIHelper.buildBottomButtons(
            context: context,
            onBack: widget.onBack,
            onPay: !_isLoading ? () => _handlePayment(context) : null,
            isLoading: _isLoading,
            amount: widget.amount,
            formatPrice: formatPrice,
          ),
        ),
      ],
    );
  }
}
