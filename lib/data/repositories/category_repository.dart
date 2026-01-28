import 'package:get/get.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/services/supabase_service.dart';
import '../models/category_model.dart';

/// Repository for category operations
class CategoryRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  /// Fetch all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.categoriesTable)
          .select()
          .order('name');

      return (response as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CategoryRepositoryException('Failed to fetch categories: $e');
    }
  }

  /// Get a single category by ID
  Future<CategoryModel?> getCategoryById(int categoryId) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.categoriesTable)
          .select()
          .eq('category_id', categoryId)
          .maybeSingle();

      if (response == null) return null;
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw CategoryRepositoryException('Failed to fetch category: $e');
    }
  }
}

/// Category repository exception
class CategoryRepositoryException implements Exception {
  final String message;

  CategoryRepositoryException(this.message);

  @override
  String toString() => 'CategoryRepositoryException: $message';
}
