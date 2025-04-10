import 'package:bid/components/address_widgets/address_search_field.dart';
import 'package:flutter/material.dart';

class AddressInfoForm extends StatelessWidget {
  final TextEditingController streetAddressController;
  final TextEditingController apartmentController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final TextEditingController countryController;
  final bool isSearching;
  final List<Map<String, dynamic>> searchResults;
  final Function(String) onSearch;
  final Function() onClear;
  final Function(Map<String, dynamic>) onSelectPlace;
  final String mapboxApiKey;

  const AddressInfoForm({
    Key? key,
    required this.streetAddressController,
    required this.apartmentController,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.countryController,
    required this.isSearching,
    required this.searchResults,
    required this.onSearch,
    required this.onClear,
    required this.onSelectPlace,
    required this.mapboxApiKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),

        // Street Address with Autocomplete
        AddressSearchField(
          controller: streetAddressController,
          isSearching: isSearching,
          searchResults: searchResults,
          onSearch: onSearch,
          onClear: onClear,
          onSelectPlace: onSelectPlace,
        ),

        const SizedBox(height: 16),

        // Apartment
        TextFormField(
          controller: apartmentController,
          decoration: const InputDecoration(
            labelText: 'Apartment, Suite, etc. (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // City
        TextFormField(
          controller: cityController,
          decoration: const InputDecoration(
            labelText: 'City',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your city';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // State
        TextFormField(
          controller: stateController,
          decoration: const InputDecoration(
            labelText: 'State/Province',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your state';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Postal Code
        TextFormField(
          controller: postalCodeController,
          decoration: const InputDecoration(
            labelText: 'Postal Code',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your postal code';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Country
        TextFormField(
          controller: countryController,
          decoration: const InputDecoration(
            labelText: 'Country',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your country';
            }
            return null;
          },
        ),
      ],
    );
  }
}
