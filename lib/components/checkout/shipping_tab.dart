
import 'package:bid/components/checkout/payment_tab.dart';
import 'package:bid/utils/shipping_tab_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShippingTab extends ConsumerStatefulWidget {
  final VoidCallback onProceed;
  final VoidCallback onBack;

  const ShippingTab({
    Key? key,
    required this.onProceed,
    required this.onBack,
  }) : super(key: key);

  @override
  ConsumerState<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends ConsumerState<ShippingTab> with AutomaticKeepAliveClientMixin {
  bool _showAddressSelector = false;

  @override
  bool get wantKeepAlive => false; // Changed to false to prevent keeping state between sessions

  @override
  void initState() {
    super.initState();
    // Ensure addresses are loaded or cleared based on login state
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(autoLoadAddressesProvider);
    // });
  }

  void _handleAddressSelected(dynamic address) {
    setState(() {
      _showAddressSelector = false;
    });
  }

  void _handleAddressCardTap() {
    setState(() {
      _showAddressSelector = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final selectedAddress = ref.watch(effectiveAddressProvider);
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
                // Shipping Information
                ShippingTabUIHelper.buildShippingInformation(
                  context: context,
                  showAddressSelector: _showAddressSelector,
                  selectedAddress: selectedAddress,
                  onAddressSelected: _handleAddressSelected,
                  onAddressCardTap: _handleAddressCardTap,
                ),

                const SizedBox(height: 24),

                // Shipping method
                ShippingTabUIHelper.buildShippingMethod(context),
              ],
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
          child: ShippingTabUIHelper.buildBottomButtons(
            context: context,
            onBack: widget.onBack,
            onProceed: widget.onProceed,
            canProceed: selectedAddress != null,
          ),
        ),
      ],
    );
  }
}
