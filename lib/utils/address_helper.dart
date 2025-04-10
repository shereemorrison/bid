// components/address_widgets/address_builder.dart
import 'package:bid/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddressBuilder {
  static AddressModel buildAddress({
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
    AddressModel? existingAddress,
  }) {
    if (existingAddress != null) {
      return AddressModel(
        addressId: existingAddress.addressId,
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
      return AddressModel(
        addressId: const Uuid().v4(),
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