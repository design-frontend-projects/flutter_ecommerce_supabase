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

  /// Load products with pagination
  Future<void> loadProducts({bool refresh = false}) async {
    if (_isLoading.value) return;

    if (refresh) {
      _currentPage.value = 0;
      _hasMore.value = true;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final newProducts = await _productRepository.getProducts(
        page: _currentPage.value,
        limit: AppConstants.pageSize,
      );

      if (refresh) {
        _products.clear();
      }

      _products.addAll(newProducts);
      _hasMore.value = newProducts.length >= AppConstants.pageSize;
      _currentPage.value++;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load more products (pagination)
  Future<void> loadMore() async {
    if (_isLoadingMore.value || !_hasMore.value) return;

    _isLoadingMore.value = true;

    try {
      List<ProductModel> newProducts;

      if (_searchQuery.value.isNotEmpty) {
        newProducts = await _productRepository.searchProducts(
          query: _searchQuery.value,
          page: _currentPage.value,
          limit: AppConstants.pageSize,
        );
      } else {
        newProducts = await _productRepository.getProducts(
          page: _currentPage.value,
          limit: AppConstants.pageSize,
        );
      }

      _products.addAll(newProducts);
      _hasMore.value = newProducts.length >= AppConstants.pageSize;
      _currentPage.value++;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoadingMore.value = false;
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
  Future<void> refresh() async {
    if (_searchQuery.value.isNotEmpty) {
      await _performSearch(_searchQuery.value);
    } else {
      await loadProducts(refresh: true);
    }
  }
}
