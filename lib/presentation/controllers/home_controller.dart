import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/debouncer.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

/// Home controller for products list and search
class HomeController extends GetxController {
  final ProductRepository _productRepository = ProductRepository();
  final Debouncer _debouncer = Debouncer(
    delay: Duration(milliseconds: AppConstants.searchDebounceMs),
  );

  final RxList<ProductModel> _products = <ProductModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _hasMore = true.obs;
  final RxString _errorMessage = ''.obs;
  final RxInt _currentPage = 0.obs;

  // Search state
  final RxBool _isSearching = false.obs;
  final RxString _searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMore => _hasMore.value;
  String get errorMessage => _errorMessage.value;
  bool get isSearching => _isSearching.value;
  String get searchQuery => _searchQuery.value;
  bool get hasProducts => _products.isNotEmpty;
  bool get isEmpty => !isLoading && _products.isEmpty;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  @override
  void onClose() {
    _debouncer.dispose();
    searchController.dispose();
    super.onClose();
  }

  StreamSubscription<List<ProductModel>>? _productsSubscription;

  /// Subscribe to products stream
  void loadProducts({bool refresh = false}) {
    if (_isSearching.value && _searchQuery.value.isNotEmpty) {
      _performSearch(_searchQuery.value);
      return;
    }

    if (refresh) {
      _products.clear();
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    _productsSubscription?.cancel();
    _productsSubscription = _productRepository.streamProducts().listen(
      (newProducts) {
        _products.assignAll(newProducts);
        _hasMore.value = false; // Stream updates replace manual pagination
        _isLoading.value = false;
      },
      onError: (error) {
        _errorMessage.value = error.toString();
        _isLoading.value = false;
      },
    );
  }

  /// Load more products (pagination) - currently disabled for streams
  Future<void> loadMore() async {
    // If searching, we could implement pagination.
    // For streams, we get real-time updates of all matched so pagination is omitted here for simplicity.
    if (_isLoadingMore.value || !_hasMore.value) return;

    if (_isSearching.value && _searchQuery.value.isNotEmpty) {
      _isLoadingMore.value = true;
      try {
        final newProducts = await _productRepository.searchProducts(
          query: _searchQuery.value,
          page: _currentPage.value,
          limit: AppConstants.pageSize,
        );
        _products.addAll(newProducts);
        _hasMore.value = newProducts.length >= AppConstants.pageSize;
        _currentPage.value++;
      } catch (e) {
        _errorMessage.value = e.toString();
      } finally {
        _isLoadingMore.value = false;
      }
    }
  }

  /// Toggle search mode
  void toggleSearch() {
    _isSearching.value = !_isSearching.value;
    if (!_isSearching.value) {
      clearSearch();
    }
  }

  /// Open search mode
  void openSearch() {
    _isSearching.value = true;
  }

  /// Close search mode
  void closeSearch() {
    _isSearching.value = false;
    clearSearch();
  }

  /// Handle search query change with debounce
  void onSearchChanged(String query) {
    _searchQuery.value = query;

    if (query.length < AppConstants.minSearchLength) {
      if (query.isEmpty) {
        _debouncer.cancel();
        _resetToProducts();
      }
      return;
    }

    _debouncer.run(() => _performSearch(query));
  }

  /// Perform server-side search
  Future<void> _performSearch(String query) async {
    _isLoading.value = true;
    _currentPage.value = 0;
    _errorMessage.value = '';

    try {
      final results = await _productRepository.searchProducts(
        query: query,
        page: 0,
        limit: AppConstants.pageSize,
      );

      _products.clear();
      _products.addAll(results);
      _hasMore.value = results.length >= AppConstants.pageSize;
      _currentPage.value = 1;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Clear search and restore products
  void clearSearch() {
    _debouncer.cancel();
    searchController.clear();
    _searchQuery.value = '';
    _resetToProducts();
  }

  /// Reset to default products list
  void _resetToProducts() {
    _currentPage.value = 0;
    _hasMore.value = true;
    loadProducts(refresh: true);
  }

  /// Refresh products
  Future<void> refreshData() async {
    if (_searchQuery.value.isNotEmpty) {
      await _performSearch(_searchQuery.value);
    } else {
      loadProducts(refresh: true);
    }
  }
}
