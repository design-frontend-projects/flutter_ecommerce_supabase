import 'package:get/get.dart';
import '../../data/models/favorite_model.dart';
import '../../data/repositories/favorites_repository.dart';
import 'auth_controller.dart';

/// Favorites controller with offline-first support
class FavoritesController extends GetxController {
  final FavoritesRepository _favoritesRepository = FavoritesRepository();

  final RxList<FavoriteModel> _favorites = <FavoriteModel>[].obs;
  final RxSet<int> _favoriteIds = <int>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  List<FavoriteModel> get favorites => _favorites;
  Set<int> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  int get count => _favorites.length;

  int? get _customerId => Get.find<AuthController>().customerId;

  @override
  void onInit() {
    super.onInit();
    _loadCachedFavorites();
    syncFavorites();
  }

  /// Load cached favorites immediately
  void _loadCachedFavorites() {
    final cached = _favoritesRepository.getCachedFavorites();
    _favorites.assignAll(cached);
    _favoriteIds.assignAll(_favoritesRepository.getCachedFavoriteIds());
  }

  /// Sync favorites with server
  Future<void> syncFavorites() async {
    if (_customerId == null) return;

    _isLoading.value = true;
    try {
      final serverFavorites = await _favoritesRepository.getFavorites(
        _customerId!,
      );
      _favorites.assignAll(serverFavorites);
      _favoriteIds.assignAll(serverFavorites.map((f) => f.productId));
    } catch (e) {
      // Keep cached data on error
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Check if product is favorited (from local cache)
  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(int productId) async {
    if (_customerId == null) {
      Get.snackbar('Login Required', 'Please login to add favorites');
      return;
    }

    if (isFavorite(productId)) {
      await removeFavorite(productId);
    } else {
      await addFavorite(productId);
    }
  }

  /// Add product to favorites with optimistic update
  Future<void> addFavorite(int productId) async {
    if (_customerId == null) return;

    // Optimistic update
    _favoriteIds.add(productId);

    try {
      await _favoritesRepository.addFavorite(
        customerId: _customerId!,
        productId: productId,
      );
      await syncFavorites();
    } catch (e) {
      // Rollback on error
      _favoriteIds.remove(productId);
      _errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to add favorite');
    }
  }

  /// Remove product from favorites with optimistic update
  Future<void> removeFavorite(int productId) async {
    if (_customerId == null) return;

    // Optimistic update
    _favoriteIds.remove(productId);
    _favorites.removeWhere((f) => f.productId == productId);

    try {
      await _favoritesRepository.removeFavorite(
        customerId: _customerId!,
        productId: productId,
      );
    } catch (e) {
      // Rollback on error
      await syncFavorites();
      _errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to remove favorite');
    }
  }

  /// Clear all favorites (for logout)
  void clearFavorites() {
    _favorites.clear();
    _favoriteIds.clear();
  }
}
