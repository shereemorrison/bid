import 'package:flutter/material.dart';
import 'package:bid/models/products_model.dart';
import 'package:bid/components/common_widgets/search_bar.dart';
import 'package:bid/components/product_widgets/product_grid_item.dart';

// Helper for building shop page title
Widget buildPageTitle(BuildContext context, String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    ),
  );
}

// Helper for building section titles
Widget buildSectionTitle(BuildContext context, String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.secondary,
    ),
  );
}

// Helper for building product grids
Widget buildProductGrid(
    BuildContext context,
    List<Product> products,
    bool isLoading,
    String? error,
    Future<void> Function() onRefresh
    ) {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (error != null) {
    return Center(child: Text(error, style: TextStyle(color: Colors.red)));
  }

  if (products.isEmpty) {
    return const Center(child: Text('No products found'));
  }

  return RefreshIndicator(
    onRefresh: () async {
      onRefresh();
      return Future.value();
    },
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductGridItem(product: products[index]);
      },
    ),
  );
}

// Helper for building a standard shop page layout
Widget buildShopPageLayout(
    BuildContext context,
    String pageTitle,
    List<Product> products,
    bool isLoading,
    String? error,
    Future<void> Function() onRefresh
    ) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          buildPageTitle(context, pageTitle),
          const SizedBox(height: 16),

          // Search Bar
          const CustomSearchBar(),
          const SizedBox(height: 24),

          // All Products Section
          buildSectionTitle(context, "All Products"),
          const SizedBox(height: 12),

          // Grid of Products
          Expanded(
            child: buildProductGrid(
                context,
                products,
                isLoading,
                error,
                onRefresh
            ),
          ),
        ],
      ),
    ),
  );
}

