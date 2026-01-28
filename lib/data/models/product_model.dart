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
    return ProductModel(
      productId: json['product_id'] as int,
      categoryId: json['category_id'] as int?,
      supplierId: json['supplier_id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      basePrice: (json['base_price'] as num).toDouble(),
      costPrice: (json['cost_price'] as num).toDouble(),
      sku: json['sku'] as String,
      barcode: json['barcode'] as String?,
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      dimensions: json['dimensions'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      category: json['categories'] != null
          ? CategoryModel.fromJson(json['categories'] as Map<String, dynamic>)
          : null,
      imageUrl: json['image_url'] as String?,
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
