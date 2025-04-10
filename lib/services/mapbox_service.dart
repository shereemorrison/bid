import 'dart:convert';
import 'package:http/http.dart' as http;

class MapboxService {
  final String apiKey;

  MapboxService({required this.apiKey});

  Future<List<Map<String, dynamic>>> searchAddress(String query) async {
    if (query.length < 3) {
      return [];
    }

    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedQuery.json?access_token=$apiKey&country=au&limit=5&types=address';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        return List<Map<String, dynamic>>.from(features);
      } else {
        print('Error searching for address: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error searching for address: $e');
      return [];
    }
  }

  Map<String, String> parseAddressComponents(Map<String, dynamic> place) {
    final placeName = place['place_name'] as String? ?? '';
    print('Place name: $placeName');

    // Initialize variables
    String street = '';
    String city = '';
    String state = '';
    String postalCode = '';
    String country = 'Australia';

    // Extract postal code using regex - Australian postcodes are 4 digits
    final postalCodeRegex = RegExp(r'\b\d{4}\b');
    final postalCodeMatch = postalCodeRegex.firstMatch(placeName);
    if (postalCodeMatch != null) {
      postalCode = postalCodeMatch.group(0) ?? '';
      print('Found postal code: $postalCode');
    }

    // Extract other components from place_name
    final addressParts = placeName.split(', ');
    print('Address parts: $addressParts');

    if (addressParts.length >= 1) {
      // First part is the street address
      street = addressParts[0];
    }

    if (addressParts.length >= 2) {
      // Second part contains city, state, and postal code
      final locationPart = addressParts[1];

      // Extract city and state
      // The format is typically "City State Postcode"
      // Remove the postal code first
      final locationWithoutPostcode = locationPart.replaceAll(postalCodeRegex, '').trim();

      // Split by spaces to separate city and state
      final locationComponents = locationWithoutPostcode.split(' ');

      if (locationComponents.length > 1) {
        // Last word is likely the state
        state = locationComponents.last;

        // Everything before the state is the city
        city = locationComponents.sublist(0, locationComponents.length - 1).join(' ');
      } else {
        // If there's only one component, assume it's the city
        city = locationWithoutPostcode;
      }
    }

    if (addressParts.length >= 3) {
      // Third part is the country
      country = addressParts[2];
    }

    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }
}
