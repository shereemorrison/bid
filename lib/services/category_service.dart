import '../models/category_model.dart';

// This service will eventually fetch data from Firebase
class CategoryService {
  // Mock data for now - will be replaced with Firebase fetch
  Future<List<Category>> getCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      Category(
        id: '1',
        name: 'Men',
        route: '/shop-men',
        imageUrl: 'assets/images/men_category.jpg',
      ),
      Category(
        id: '2',
        name: 'Women',
        route: '/shop-women',
        imageUrl: 'assets/images/women_category.jpg',
      ),
      Category(
        id: '3',
        name: 'Accessories',
        route: '/accessories',
        imageUrl: 'assets/images/accessories_category.jpg',
      ),
      Category(
        id: '4',
        name: 'BID Exclusives',
        route: '/bid-exclusives',
        imageUrl: 'assets/images/exclusives_category.jpg',
      ),
    ];
  }
}
