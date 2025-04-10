import 'package:bid/models/address_model.dart';
import 'package:flutter/material.dart';

class OrderAddressCard extends StatelessWidget {
  final AddressModel? address;
  final VoidCallback onTap;

  const OrderAddressCard({
    Key? key,
    this.address,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: address != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${address!.firstName} ${address!.lastName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address!.formattedAddress,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
                    : const Text(
                  'Add shipping address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
