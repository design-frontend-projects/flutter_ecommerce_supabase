import 'package:get/get.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/services/supabase_service.dart';
import '../models/product_model.dart';

/// Repository for product operations
class ProductRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  /// Fetch products with pagination
  Future<List<ProductModel>> getProducts({
    int page = 0,
    int limit = 20,
    int? categoryId,
    bool activeOnly = true,
  }) async {
    try {
      var query = _supabase
          .from(SupabaseConstants.productsTable)
          .select('*, categories(*)');

      if (activeOnly) {
        query = query.eq('is_active', true);
      }

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      final response = await query
          .range(page * limit, (page + 1) * limit - 1)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw RepositoryException('Failed to fetch products: $e');
    }
  }

  /// Stream products with real-time updates
  Stream<List<ProductModel>> streamProducts({
    int? categoryId,
    bool activeOnly = true,
  }) {
    Stream<List<Map<String, dynamic>>> stream;

    if (categoryId != null) {
      stream = _supabase
          .from(SupabaseConstants.productsTable)
          .stream(primaryKey: ['product_id'])
          .eq('category_id', categoryId);
    } else if (activeOnly) {
      stream = _supabase
          .from(SupabaseConstants.productsTable)
          .stream(primaryKey: ['product_id'])
          .eq('is_active', true);
    } else {
      stream = _supabase
          .from(SupabaseConstants.productsTable)
          .stream(primaryKey: ['product_id']);
    }

    return stream.map((list) {
      var products = list.map((e) => ProductModel.fromJson(e)).toList();

      // Since Supabase streams only support one filter, we apply the second one locally
      if (categoryId != null && activeOnly) {
        products = products.where((p) => p.isActive).toList();
      }

      // Sort by created_at descending
      products.sort(
        (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
          a.createdAt ?? DateTime.now(),
        ),
      );
      return products;
    });
  }

  /// Search products with server-side filtering
  Future<List<ProductModel>> searchProducts({
    required String query,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final searchTerm = '%$query%';

      final response = await _supabase
          .from(SupabaseConstants.productsTable)
          .select('*, categories(*)')
          .eq('is_active', true)
          .or('name.ilike.$searchTerm,description.ilike.$searchTerm')
          .range(page * limit, (page + 1) * limit - 1)
          .order('name');

      return (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw RepositoryException('Failed to search products: $e');
    }
  }

  /// Get a single product by ID
  Future<ProductModel?> getProductById(int productId) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.productsTable)
          .select('*, categories(*)')
          .eq('product_id', productId)
          .maybeSingle();

      if (response == null) return null;
      return ProductModel.fromJson(response);
    } catch (e) {
      throw RepositoryException('Failed to fetch product: $e');
    }
  }

  /// Get products by category
  Future<List<ProductModel>> getProductsByCategory(
    int categoryId, {
    int page = 0,
    int limit = 20,
  }) async {
    return getProducts(page: page, limit: limit, categoryId: categoryId);
  }

  /// Get product count
  Future<int> getProductCount({int? categoryId}) async {
    try {
      var query = _supabase
          .from(SupabaseConstants.productsTable)
          .select('product_id')
          .eq('is_active', true);

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      final response = await query;
      return (response as List).length;
    } catch (e) {
      throw RepositoryException('Failed to get product count: $e');
    }
  }
}

/// Repository exception
class RepositoryException implements Exception {
  final String message;

  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}
