import 'package:bid/components/address_widgets/address_contact_info.dart';
import 'package:bid/components/address_widgets/address_type_toggle.dart';
import 'package:bid/components/address_widgets/contact_info_form.dart';
import 'package:bid/models/address_model.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddressForm extends ConsumerStatefulWidget {
  final Address? addressToEdit;
  final Function(Address) onSave;

  const AddressForm({Key? key, this.addressToEdit, required this.onSave})
      : super(key: key);

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  String _addressType = 'shipping';
  bool _isDefault = true;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.addressToEdit != null) {
      final address = widget.addressToEdit!;
      _firstNameController.text = address.firstName ?? '';
      _lastNameController.text = address.lastName ?? '';
      _phoneController.text = address.phone ?? '';
      _emailController.text = address.email ?? '';
      _streetAddressController.text = address.streetAddress;
      _apartmentController.text = address.apartment ?? '';
      _cityController.text = address.city;
      _stateController.text = address.state;
      _postalCodeController.text = address.postalCode;
      _countryController.text = address.country;
      _addressType = address.addressType;
      _isDefault = address.isDefault;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userData = ref.read(userDataProvider);
        if (userData != null) {
          _firstNameController.text = userData.firstName ?? '';
          _lastNameController.text = userData.lastName ?? '';
          _phoneController.text = userData.phone ?? '';
          _emailController.text = userData.email;
        }
        _countryController.text = 'Australia';
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetAddressController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress(String query) async {
    if (query.length < 3) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);

    try {
      final mapbox = ref.read(mapboxServiceProvider);
      final results = await mapbox.searchAddress(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _selectPlace(Map<String, dynamic> place) {
    final components =
        ref.read(mapboxServiceProvider).parseAddressComponents(place);
    setState(() {
      _streetAddressController.text = components['street'] ?? '';
      _cityController.text = components['city'] ?? '';
      _stateController.text = components['state'] ?? '';
      _postalCodeController.text = components['postalCode'] ?? '';
      _countryController.text = components['country'] ?? '';
      _searchResults = [];
    });
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      final isLoggedIn = ref.read(isLoggedInProvider);
      final addressRepository = ref.read(addressRepositoryProvider);
      String? userId;

      if (isLoggedIn) {
        await ref.read(authProvider.notifier).refreshUserData();
        userId = ref.read(userDataProvider)?.userId;
      }

      if (!isLoggedIn) {
        final userRepository = ref.read(userRepositoryProvider);
        final normalizedEmail = _emailController.text.trim().toLowerCase();
        final guestProfile = await userRepository.ensureGuestProfile(
          email: normalizedEmail,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
        userId = guestProfile.userId;
        ref.read(sessionProvider.notifier).setGuestUserId(userId);
      }

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to save address')),
        );
        setState(() => _isSaving = false);
        return;
      }

      // Create address object
      final address = Address(
        id: widget.addressToEdit?.id ?? const Uuid().v4(),
        userId: userId,
        addressType: _addressType,
        isDefault: _isDefault,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        streetAddress: _streetAddressController.text,
        apartment: _apartmentController.text.isEmpty ? null : _apartmentController.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _postalCodeController.text,
        country: _countryController.text,
        createdAt: widget.addressToEdit?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final saved = await addressRepository.saveAddress(address);
      if (!saved) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save address')),
          );
        }
        setState(() => _isSaving = false);
        return;
      }

      if (isLoggedIn) {
        final userRepository = ref.read(userRepositoryProvider);
        final authId = userRepository.currentUserId;
        if (authId != null) {
          await userRepository.updateUserProfile(authId, {
            'first_name': address.firstName,
            'last_name': address.lastName,
            'phone': address.phone,
          });
          await ref.read(authProvider.notifier).refreshUserData();
        }
      }

      widget.onSave(address);
      if (mounted) {
        Navigator.of(context).pop(address);
      }
    } catch (e) {
      print('Error saving address: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.addressToEdit != null ? 'Edit Address' : 'Add Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddressTypeSelector(
                  selectedType: _addressType,
                  onTypeSelected: (type) => setState(() => _addressType = type),
                ),
                const SizedBox(height: 24),
                ContactInfoForm(
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  phoneController: _phoneController,
                  emailController: _emailController,
                ),
                const SizedBox(height: 24),
                AddressInfoForm(
                  streetAddressController: _streetAddressController,
                  apartmentController: _apartmentController,
                  cityController: _cityController,
                  stateController: _stateController,
                  postalCodeController: _postalCodeController,
                  countryController: _countryController,
                  isSearching: _isSearching,
                  searchResults: _searchResults,
                  onSearch: _searchAddress,
                  onClear: () => setState(() {
                    _streetAddressController.clear();
                    _searchResults = [];
                  }),
                  onSelectPlace: _selectPlace,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text('Save Address'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
