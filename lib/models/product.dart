class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String type;
  final List<String> tags;
  final List<String> images;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.tags,
    required this.images,
    this.isFavorite = false,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      price: (map['price'] as num).toDouble(),
      type: map['type'] as String? ?? 'Other',
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      images: (map['images'] as List<dynamic>?)?.cast<String>() ?? [],
      isFavorite: map['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'type': type,
      'tags': tags,
      'images': images,
      'is_favorite': isFavorite,
    };
  }
}
