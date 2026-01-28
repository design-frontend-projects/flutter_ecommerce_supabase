import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

/// Repository for cart operations (local only)
class CartRepository {
  final StorageService _storage = Get.find<StorageService>();

  /// Get all cart items
  List<CartItemModel> getCartItems() {
    final data = _storage.readJsonList(AppConstants.cartKey);
    if (data == null) return [];
    return data.map((e) => CartItemModel.fromJson(e)).toList();
  }

  /// Add item to cart
  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    final items = getCartItems();
    final existingIndex = items.indexWhere(
      (item) => item.productId == product.productId,
    );

    if (existingIndex >= 0) {
      // Update quantity if item exists
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item
      items.add(CartItemModel.fromProduct(product, quantity: quantity));
    }

    await _saveCart(items);
  }

  /// Remove item from cart
  Future<void> removeFromCart(int productId) async {
    final items = getCartItems();
    items.removeWhere((item) => item.productId == productId);
    await _saveCart(items);
  }

  /// Update item quantity
  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final items = getCartItems();
    final index = items.indexWhere((item) => item.productId == productId);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: quantity);
      await _saveCart(items);
    }
  }

  /// Increment item quantity
  Future<void> incrementQuantity(int productId) async {
    final items = getCartItems();
    final index = items.indexWhere((item) => item.productId == productId);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
      await _saveCart(items);
    }
  }

  /// Decrement item quantity
  Future<void> decrementQuantity(int productId) async {
    final items = getCartItems();
    final index = items.indexWhere((item) => item.productId == productId);

    if (index >= 0) {
      final newQuantity = items[index].quantity - 1;
      if (newQuantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = items[index].copyWith(quantity: newQuantity);
      }
      await _saveCart(items);
    }
  }

  /// Clear cart
  Future<void> clearCart() async {
    await _storage.remove(AppConstants.cartKey);
  }

  /// Get cart item count
  int get itemCount {
    return getCartItems().fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get cart total
  double get total {
    return getCartItems().fold(0, (sum, item) => sum + item.totalPrice);
  }

  /// Check if product is in cart
  bool isInCart(int productId) {
    return getCartItems().any((item) => item.productId == productId);
  }

  /// Get quantity for a product
  int getQuantity(int productId) {
    final item = getCartItems().firstWhereOrNull(
      (item) => item.productId == productId,
    );
    return item?.quantity ?? 0;
  }

  /// Save cart to storage
  Future<void> _saveCart(List<CartItemModel> items) async {
    await _storage.writeJsonList(
      AppConstants.cartKey,
      items.map((e) => e.toJson()).toList(),
    );
  }
}
