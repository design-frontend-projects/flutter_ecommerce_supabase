import 'category_model.dart';

/// Product model
class ProductModel {
  final int productId;
  final int? categoryId;
  final int? supplierId;
  final String name;
  final String? description;
  final double basePrice;
  final double costPrice;
  final String sku;
  final String? barcode;
  final double? weight;
  final String? dimensions;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CategoryModel? category;
  final String? imageUrl;

  ProductModel({
    required this.productId,
    this.categoryId,
    this.supplierId,
    required this.name,
    this.description,
    required this.basePrice,
    required this.costPrice,
    required this.sku,
    this.barcode,
    this.weight,
    this.dimensions,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    double? parseNullableDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    int parseInt(dynamic value) {
      return parseNullableInt(value) ?? 0;
    }

    return ProductModel(
      productId: parseInt(json['product_id']),
      categoryId: parseNullableInt(json['category_id']),
      supplierId: parseNullableInt(json['supplier_id']),
      name: json['name']?.toString() ?? 'Unknown',
      description: json['description']?.toString(),
      basePrice: parseDouble(json['base_price']),
      costPrice: parseDouble(json['cost_price']),
      sku: json['sku']?.toString() ?? '',
      barcode: json['barcode']?.toString(),
      weight: parseNullableDouble(json['weight']),
      dimensions: json['dimensions']?.toString(),
      isActive: json['is_active'] is bool
          ? json['is_active'] as bool
          : (json['is_active']?.toString().toLowerCase() == 'true'),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      category: json['categories'] != null
          ? CategoryModel.fromJson(json['categories'] as Map<String, dynamic>)
          : null,
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'category_id': categoryId,
      'supplier_id': supplierId,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'cost_price': costPrice,
      'sku': sku,
      'barcode': barcode,
      'weight': weight,
      'dimensions': dimensions,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'image_url': imageUrl,
    };
  }

  ProductModel copyWith({
    int? productId,
    int? categoryId,
    int? supplierId,
    String? name,
    String? description,
    double? basePrice,
    double? costPrice,
    String? sku,
    String? barcode,
    double? weight,
    String? dimensions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    CategoryModel? category,
    String? imageUrl,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      costPrice: costPrice ?? this.costPrice,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
