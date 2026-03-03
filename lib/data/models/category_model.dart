/// Category model
class CategoryModel {
  final int categoryId;
  final String name;
  final String? description;
  final DateTime? createdAt;

  CategoryModel({
    required this.categoryId,
    required this.name,
    this.description,
    this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    int parseInt(dynamic value) {
      return parseNullableInt(value) ?? 0;
    }

    return CategoryModel(
      categoryId: parseInt(json['category_id']),
      name: json['name']?.toString() ?? 'Unknown',
      description: json['description']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
