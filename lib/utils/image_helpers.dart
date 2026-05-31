import 'package:bid/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:bid/supabase/supabase_config.dart';

bool isUrl(String path) {
  return path.startsWith('http');
}

// Get Supabase URL for an image path
String getSupabaseImageUrl(String imagePath) {
  if (imagePath.isEmpty || imagePath == "null") {
    return '';
  }

  // If it's already a full URL, return it
  if (imagePath.startsWith('http')) {
    return imagePath;
  }

  // Get public URL from Supabase storage
  try {
    return SupabaseConfig.client.storage.from('bid-images').getPublicUrl(imagePath);
  } catch (e) {
    print('Error getting Supabase image URL: $e');
    return '';
  }
}

// Special image methods from the old HomeService
String getHeroImageUrl() {
  return getSupabaseImageUrl('products/training.jpg');
}

String getOurStoryImageUrl() {
  return getSupabaseImageUrl('products/wraps.jpg');
}

/// Set to `true` after running `scripts/upload_collection_banners.py --preset categories`.
const bool kUseCollectionBannerImages = false;

/// Set to `true` after running `scripts/upload_collection_banners.py --preset seasonal`.
const bool kUseSeasonalBannerImages = false;

/// Carousel banners: Winter / Holiday / Essentials.
String getCollectionImageUrl(int index) {
  const banners = [
    'collections/winter.jpg',
    'collections/holiday.jpg',
    'collections/essentials.jpg',
  ];
  const fallbacks = [
    'products/BIDHoodie2.jpg',
    'products/BIDSweater2.jpg',
    'products/tshirt3.jpg',
  ];

  final paths = kUseSeasonalBannerImages ? banners : fallbacks;
  if (index >= 0 && index < paths.length) {
    return getSupabaseImageUrl(paths[index]);
  }
  return '';
}

/// COLLECTIONS section tiles: Men / Women / Accessories / Sale.
String getCategoryTileImageUrl(String slug) {
  const banners = {
    'men': 'collections/men.jpg',
    'women': 'collections/women.jpg',
    'accessories': 'collections/accessories.jpg',
    'sale': 'collections/sale.jpg',
  };
  const fallbacks = {
    'men': 'products/BIDHoodie.jpg',
    'women': 'products/womanlightgreyhoodie.jpg',
    'accessories': 'products/bluebag.jpg',
    'sale': 'products/greytshirt.jpg',
  };

  final path = kUseCollectionBannerImages
      ? banners[slug]
      : fallbacks[slug];
  if (path == null) return '';
  return getSupabaseImageUrl(path);
}

Widget buildProductImage(BuildContext context, String imageUrl, String imagePath) {

  // Check for empty paths
  if ((imageUrl.isEmpty || imageUrl == "null") && (imagePath.isEmpty || imagePath == "null")) {
    return buildPlaceholderImage(context, Icons.image_not_supported);
  }

  // Determine which path to use
  final String pathToUse = imageUrl.isNotEmpty && imageUrl != "null" ? imageUrl : imagePath;

  // Always convert to Supabase URL if not already a URL
  final String finalImageUrl = isUrl(pathToUse) ? pathToUse : getSupabaseImageUrl(pathToUse);

  // Debug the image URL
  //print('Loading image from: $finalImageUrl');

  // If no valid URL could be generated
  if (finalImageUrl.isEmpty) {
    return buildPlaceholderImage(context, Icons.image_not_supported);
  }

  // Always use Image.network since we're always using Supabase
  return Image.network(
    finalImageUrl,
    fit: BoxFit.cover,
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return buildLoadingIndicator(context, loadingProgress);
    },
    errorBuilder: (context, error, stackTrace) {
      return buildPlaceholderImage(context, Icons.error_outline);
    },
  );
}

// Helper method for placeholder images
Widget buildPlaceholderImage(BuildContext context, IconData icon) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    color: colorScheme.cardBackground,
    child: Center(
      child: Icon(icon, color: colorScheme.primary),
    ),
  );
}

// Helper method for loading indicators
Widget buildLoadingIndicator(BuildContext context, ImageChunkEvent loadingProgress) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(
    color: colorScheme.cardBackground,
    child: Center(
      child: CircularProgressIndicator(
        color: colorScheme.primary,
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
            : null,
      ),
    ),
  );
}

