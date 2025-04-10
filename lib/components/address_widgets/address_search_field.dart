import 'package:flutter/material.dart';

class AddressSearchField extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final List<Map<String, dynamic>> searchResults;
  final Function(String) onSearch;
  final Function() onClear;
  final Function(Map<String, dynamic>) onSelectPlace;

  const AddressSearchField({
    Key? key,
    required this.controller,
    required this.isSearching,
    required this.searchResults,
    required this.onSearch,
    required this.onClear,
    required this.onSelectPlace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Street Address',
            border: const OutlineInputBorder(),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: onClear,
            )
                : null,
          ),
          onChanged: onSearch,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your street address';
            }
            return null;
          },
        ),

        // Show search results or loading indicator
        if (isSearching)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (searchResults.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            margin: const EdgeInsets.only(top: 4),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final place = searchResults[index];
                return ListTile(
                  title: Text(place['place_name'] ?? ''),
                  dense: true,
                  onTap: () => onSelectPlace(place),
                );
              },
            ),
          ),
      ],
    );
  }
}
