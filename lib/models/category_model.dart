
class Category {
  final String id;
  final String name;
  final String route;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.route,
    this.imageUrl,
  });

  // Factory method to create a Category from Firebase data
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      route: map['route'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  // Convert Category to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'route': route,
      'imageUrl': imageUrl,
    };
  }
}