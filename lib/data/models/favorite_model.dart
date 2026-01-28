/// Favorite model for syncing with Supabase
class FavoriteModel {
  final int? favoriteId;
  final int customerId;
  final int productId;
  final DateTime? createdAt;

  FavoriteModel({
    this.favoriteId,
    required this.customerId,
    required this.productId,
    this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      favoriteId: json['favorite_id'] as int?,
      customerId: json['customer_id'] as int,
      productId: json['product_id'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (favoriteId != null) 'favorite_id': favoriteId,
      'customer_id': customerId,
      'product_id': productId,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {'customer_id': customerId, 'product_id': productId};
  }
}
