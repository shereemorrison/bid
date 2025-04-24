// components/address_widgets/address_builder.dart
import 'package:bid/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddressBuilder {
  static Address buildAddress({
    required String userId,
    required String addressType,
    required bool isDefault,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required TextEditingController streetAddressController,
    required TextEditingController apartmentController,
    required TextEditingController cityController,
    required TextEditingController stateController,
    required TextEditingController postalCodeController,
    required TextEditingController countryController,
    Address? existingAddress,
  }) {
    if (existingAddress != null) {
      return Address(
        id: existingAddress.id,
        userId: userId,
        addressType: addressType,
        isDefault: isDefault,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        streetAddress: streetAddressController.text,
        apartment: apartmentController.text,
        city: cityController.text,
        state: stateController.text,
        postalCode: postalCodeController.text,
        country: countryController.text,
        createdAt: existingAddress.createdAt,
        updatedAt: DateTime.now(),
      );
    } else {
      return Address(
        id: const Uuid().v4(),
        userId: userId,
        addressType: addressType,
        isDefault: isDefault,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        streetAddress: streetAddressController.text,
        apartment: apartmentController.text,
        city: cityController.text,
        state: stateController.text,
        postalCode: postalCodeController.text,
        country: countryController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
}