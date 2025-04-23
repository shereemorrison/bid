
import 'package:bid/components/address_widgets/address_contact_info.dart';
import 'package:bid/components/address_widgets/address_type_toggle.dart';
import 'package:bid/components/address_widgets/contact_info_form.dart';
import 'package:bid/config/api_keys.dart';
import 'package:bid/models/address_model.dart';
import 'package:bid/services/auth_service.dart';
import 'package:bid/services/mapbox_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AddressForm extends ConsumerStatefulWidget {
  final AddressModel? addressToEdit;
  final Function(AddressModel) onSave;

  const AddressForm({
    Key? key,
    this.addressToEdit,
    required this.onSave,
  }) : super(key: key);

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
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

  // Form values
  String _addressType = 'shipping';
  bool _isDefault = true;

  // Search results
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  // Mapbox API key
  final String _mapboxApiKey = ApiKeys.mapboxApiKey;
  late MapboxService _mapboxService;

  @override
  void initState() {
    super.initState();
    _mapboxService = MapboxService(apiKey: _mapboxApiKey);

    // Pre-fill form if editing
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
      // Pre-fill with user data if available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final authService = ref.read(authServiceProvider);
        final userData = ref.read(authService.userProvider);

        if (userData != null) {
          _firstNameController.text = userData.firstName ?? '';
          _lastNameController.text = userData.lastName ?? '';
          _phoneController.text = userData.phone ?? '';
          _emailController.text = userData.email;
        }

        // Default country to Australia
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
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _mapboxService.searchAddress(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Error searching for address: $e');
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _selectPlace(Map<String, dynamic> place) {
    final addressComponents = _mapboxService.parseAddressComponents(place);

    setState(() {
      _streetAddressController.text = addressComponents['street'] ?? '';
      _cityController.text = addressComponents['city'] ?? '';
      _stateController.text = addressComponents['state'] ?? '';
      _postalCodeController.text = addressComponents['postalCode'] ?? '';
      _countryController.text = addressComponents['country'] ?? '';
      _searchResults = [];
    });
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final authService = ref.read(authServiceProvider);
      final isLoggedIn = ref.read(authService.isLoggedInProvider);
      final userData = ref.read(authService.userProvider);

      // Get userId if logged in, otherwise use a temporary ID
      String userId = 'guest-${const Uuid().v4()}';
      if (isLoggedIn && userData != null) {
        userId = userData.userId;
      }

      // Create or update the address model
      final address = widget.addressToEdit != null
          ? AddressModel(
        addressId: widget.addressToEdit!.addressId,
        userId: userId,
        addressType: _addressType,
        isDefault: _isDefault,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        streetAddress: _streetAddressController.text,
        apartment: _apartmentController.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _postalCodeController.text,
        country: _countryController.text,
        createdAt: widget.addressToEdit!.createdAt,
        updatedAt: DateTime.now(),
      )
          : AddressModel(
        addressId: const Uuid().v4(),
        userId: userId,
        addressType: _addressType,
        isDefault: _isDefault,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        streetAddress: _streetAddressController.text,
        apartment: _apartmentController.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _postalCodeController.text,
        country: _countryController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Call the onSave callback
      widget.onSave(address);

      // Return to previous screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authService = ref.watch(authServiceProvider);
    final isLoggedIn = ref.watch(authService.isLoggedInProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Address type selection
                AddressTypeSelector(
                  selectedType: _addressType,
                  onTypeSelected: (type) {
                    setState(() {
                      _addressType = type;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Contact Information
                ContactInfoForm(
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  phoneController: _phoneController,
                  emailController: _emailController,
                ),

                const SizedBox(height: 24),

                // Address Information
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
                  onClear: () {
                    setState(() {
                      _streetAddressController.clear();
                      _searchResults = [];
                    });
                  },
                  onSelectPlace: _selectPlace,
                  mapboxApiKey: _mapboxApiKey,
                ),

                const SizedBox(height: 24),


                // Set as default - only show for logged in users
                if (isLoggedIn)
                  Row(
                    children: [
                      Checkbox(
                        value: _isDefault,
                        onChanged: (value) {
                          setState(() {
                            _isDefault = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Set as default ${_addressType == 'shipping' ? 'shipping' : 'billing'} address',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      widget.addressToEdit != null ? 'UPDATE ADDRESS' : 'SAVE ADDRESS',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
