class Category {
  final String id;
  final String name;
  final String route;

  Category({
    required this.id,
    required this.name,
    required this.route,
  });

  // Factory constructor to create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      route: json['route'] ?? '',
    );
  }
}
