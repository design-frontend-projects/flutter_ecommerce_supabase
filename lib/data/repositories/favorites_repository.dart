import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/supabase_service.dart';
import '../models/favorite_model.dart';

/// Repository for favorites operations with offline-first support
class FavoritesRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final StorageService _storage = Get.find<StorageService>();

  /// Get favorites from Supabase
  Future<List<FavoriteModel>> getFavorites(int customerId) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.favoritesTable)
          .select()
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      final favorites = (response as List)
          .map((e) => FavoriteModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Cache locally
      await _cacheFavorites(favorites);

      return favorites;
    } catch (e) {
      // Return cached favorites on error
      return getCachedFavorites();
    }
  }

  /// Add a product to favorites
  Future<FavoriteModel?> addFavorite({
    required int customerId,
    required int productId,
  }) async {
    try {
      // Optimistic local update
      final favorite = FavoriteModel(
        customerId: customerId,
        productId: productId,
      );
      await _addToLocalFavorites(favorite);

      // Sync to Supabase
      final response = await _supabase
          .from(SupabaseConstants.favoritesTable)
          .insert(favorite.toInsertJson())
          .select()
          .single();

      final savedFavorite = FavoriteModel.fromJson(response);

      // Update local cache with server response
      await _updateLocalFavorite(productId, savedFavorite);

      return savedFavorite;
    } catch (e) {
      // Rollback local change on error
      await _removeFromLocalFavorites(productId);
      throw FavoritesRepositoryException('Failed to add favorite: $e');
    }
  }

  /// Remove a product from favorites
  Future<void> removeFavorite({
    required int customerId,
    required int productId,
  }) async {
    try {
      // Optimistic local update
      await _removeFromLocalFavorites(productId);

      // Sync to Supabase
      await _supabase
          .from(SupabaseConstants.favoritesTable)
          .delete()
          .eq('customer_id', customerId)
          .eq('product_id', productId);
    } catch (e) {
      // Rollback - re-add locally
      await _addToLocalFavorites(
        FavoriteModel(customerId: customerId, productId: productId),
      );
      throw FavoritesRepositoryException('Failed to remove favorite: $e');
    }
  }

  /// Check if product is favorited
  Future<bool> isFavorite({
    required int customerId,
    required int productId,
  }) async {
    // Check local cache first
    final cached = getCachedFavorites();
    if (cached.any((f) => f.productId == productId)) {
      return true;
    }

    try {
      final response = await _supabase
          .from(SupabaseConstants.favoritesTable)
          .select()
          .eq('customer_id', customerId)
          .eq('product_id', productId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Get cached favorites
  List<FavoriteModel> getCachedFavorites() {
    final data = _storage.readJsonList(AppConstants.favoritesKey);
    if (data == null) return [];
    return data.map((e) => FavoriteModel.fromJson(e)).toList();
  }

  /// Get cached favorite product IDs
  Set<int> getCachedFavoriteIds() {
    return getCachedFavorites().map((f) => f.productId).toSet();
  }

  /// Sync local favorites with server
  Future<void> syncFavorites(int customerId) async {
    try {
      await getFavorites(customerId);
    } catch (e) {
      // Silent fail - use cached data
    }
  }

  /// Cache favorites locally
  Future<void> _cacheFavorites(List<FavoriteModel> favorites) async {
    await _storage.writeJsonList(
      AppConstants.favoritesKey,
      favorites.map((e) => e.toJson()).toList(),
    );
  }

  /// Add to local favorites
  Future<void> _addToLocalFavorites(FavoriteModel favorite) async {
    final cached = getCachedFavorites();
    if (!cached.any((f) => f.productId == favorite.productId)) {
      cached.add(favorite);
      await _cacheFavorites(cached);
    }
  }

  /// Remove from local favorites
  Future<void> _removeFromLocalFavorites(int productId) async {
    final cached = getCachedFavorites();
    cached.removeWhere((f) => f.productId == productId);
    await _cacheFavorites(cached);
  }

  /// Update local favorite with server data
  Future<void> _updateLocalFavorite(
    int productId,
    FavoriteModel favorite,
  ) async {
    final cached = getCachedFavorites();
    final index = cached.indexWhere((f) => f.productId == productId);
    if (index >= 0) {
      cached[index] = favorite;
      await _cacheFavorites(cached);
    }
  }
}

/// Favorites repository exception
class FavoritesRepositoryException implements Exception {
  final String message;

  FavoritesRepositoryException(this.message);

  @override
  String toString() => 'FavoritesRepositoryException: $message';
}
