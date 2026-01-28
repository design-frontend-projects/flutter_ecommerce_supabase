import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';
import 'navigation_controller.dart';

/// Orders controller
class OrdersController extends GetxController {
  final OrderRepository _orderRepository = OrderRepository();
  final CartRepository _cartRepository = CartRepository();

  final RxList<OrderModel> _orders = <OrderModel>[].obs;
  final Rx<OrderModel?> _selectedOrder = Rx<OrderModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _isCreatingOrder = false.obs;
  final RxBool _hasMore = true.obs;
  final RxString _errorMessage = ''.obs;
  final RxInt _currentPage = 0.obs;

  List<OrderModel> get orders => _orders;
  OrderModel? get selectedOrder => _selectedOrder.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get isCreatingOrder => _isCreatingOrder.value;
  bool get hasMore => _hasMore.value;
  String get errorMessage => _errorMessage.value;
  bool get hasOrders => _orders.isNotEmpty;

  int? get _customerId => Get.find<AuthController>().customerId;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  /// Load orders with pagination
  Future<void> loadOrders({bool refresh = false}) async {
    if (_customerId == null) return;
    if (_isLoading.value) return;

    if (refresh) {
      _currentPage.value = 0;
      _hasMore.value = true;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final newOrders = await _orderRepository.getOrders(
        _customerId!,
        page: _currentPage.value,
        limit: AppConstants.pageSize,
      );

      if (refresh) {
        _orders.clear();
      }

      _orders.addAll(newOrders);
      _hasMore.value = newOrders.length >= AppConstants.pageSize;
      _currentPage.value++;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load more orders
  Future<void> loadMore() async {
    if (_isLoadingMore.value || !_hasMore.value) return;

    _isLoadingMore.value = true;

    try {
      final newOrders = await _orderRepository.getOrders(
        _customerId!,
        page: _currentPage.value,
        limit: AppConstants.pageSize,
      );

      _orders.addAll(newOrders);
      _hasMore.value = newOrders.length >= AppConstants.pageSize;
      _currentPage.value++;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Get order details
  Future<void> selectOrder(int orderId) async {
    _isLoading.value = true;
    try {
      final order = await _orderRepository.getOrderById(orderId);
      _selectedOrder.value = order;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Create order from cart
  Future<bool> createOrder({
    String? shippingAddressLine1,
    String? shippingCity,
    String? shippingStateProvince,
    String? shippingPostalCode,
    String? shippingCountry,
    String? paymentMethod,
    String? notes,
  }) async {
    if (_customerId == null) return false;

    final cartItems = _cartRepository.getCartItems();
    if (cartItems.isEmpty) return false;

    _isCreatingOrder.value = true;
    _errorMessage.value = '';

    try {
      final order = await _orderRepository.createOrder(
        customerId: _customerId!,
        items: cartItems,
        shippingAddressLine1: shippingAddressLine1,
        shippingCity: shippingCity,
        shippingStateProvince: shippingStateProvince,
        shippingPostalCode: shippingPostalCode,
        shippingCountry: shippingCountry,
        paymentMethod: paymentMethod,
        notes: notes,
      );

      if (order != null) {
        // Clear cart
        await Get.find<CartController>().clearCart();

        // Refresh orders
        await loadOrders(refresh: true);

        // Show success message
        Get.snackbar(
          'Order Placed!',
          'Your order #${order.orderId} has been placed successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );

        // Navigate to orders tab
        Get.find<NavigationController>().changePage(1);
        Get.offAllNamed(AppRoutes.main);

        return true;
      }

      return false;
    } catch (e) {
      _errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to create order');
      return false;
    } finally {
      _isCreatingOrder.value = false;
    }
  }

  /// Refresh orders
  Future<void> refresh() async {
    await loadOrders(refresh: true);
  }

  /// Clear selected order
  void clearSelectedOrder() {
    _selectedOrder.value = null;
  }
}
