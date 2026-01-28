import 'package:get/get.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/cart_repository.dart';

/// Cart controller
class CartController extends GetxController {
  final CartRepository _cartRepository = CartRepository();

  final RxList<CartItemModel> _items = <CartItemModel>[].obs;
  final RxBool _isLoading = false.obs;

  List<CartItemModel> get items => _items;
  bool get isLoading => _isLoading.value;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.08;
  double get shipping => _items.isEmpty ? 0 : 5.99;
  double get total => subtotal + tax + shipping;
  bool get isEmpty => _items.isEmpty;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  /// Load cart items
  void loadCart() {
    _items.assignAll(_cartRepository.getCartItems());
  }

  /// Add product to cart
  Future<void> addToCart(ProductModel product, {int quantity = 1}) async {
    _isLoading.value = true;
    try {
      await _cartRepository.addToCart(product, quantity: quantity);
      loadCart();
      Get.snackbar(
        'Added to Cart',
        '${product.name} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(int productId) async {
    await _cartRepository.removeFromCart(productId);
    loadCart();
  }

  /// Update item quantity
  Future<void> updateQuantity(int productId, int quantity) async {
    await _cartRepository.updateQuantity(productId, quantity);
    loadCart();
  }

  /// Increment quantity
  Future<void> incrementQuantity(int productId) async {
    await _cartRepository.incrementQuantity(productId);
    loadCart();
  }

  /// Decrement quantity
  Future<void> decrementQuantity(int productId) async {
    await _cartRepository.decrementQuantity(productId);
    loadCart();
  }

  /// Clear cart
  Future<void> clearCart() async {
    await _cartRepository.clearCart();
    loadCart();
  }

  /// Check if product is in cart
  bool isInCart(int productId) {
    return _items.any((item) => item.productId == productId);
  }

  /// Get quantity for product
  int getQuantity(int productId) {
    final item = _items.firstWhereOrNull((item) => item.productId == productId);
    return item?.quantity ?? 0;
  }
}
