import 'package:get/get.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/services/supabase_service.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

/// Repository for order operations
class OrderRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  /// Get orders for a customer
  Future<List<OrderModel>> getOrders(
    int customerId, {
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.ordersTable)
          .select('*, order_items(*, products(name))')
          .eq('customer_id', customerId)
          .range(page * limit, (page + 1) * limit - 1)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw OrderRepositoryException('Failed to fetch orders: $e');
    }
  }

  /// Get a single order by ID
  Future<OrderModel?> getOrderById(int orderId) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.ordersTable)
          .select('*, order_items(*, products(name))')
          .eq('order_id', orderId)
          .maybeSingle();

      if (response == null) return null;
      return OrderModel.fromJson(response);
    } catch (e) {
      throw OrderRepositoryException('Failed to fetch order: $e');
    }
  }

  /// Create a new order from cart items
  Future<OrderModel?> createOrder({
    required int customerId,
    required List<CartItemModel> items,
    String? shippingAddressLine1,
    String? shippingAddressLine2,
    String? shippingCity,
    String? shippingStateProvince,
    String? shippingPostalCode,
    String? shippingCountry,
    String? paymentMethod,
    String? notes,
  }) async {
    try {
      // Calculate totals
      final subtotal = items.fold<double>(
        0,
        (sum, item) => sum + item.totalPrice,
      );
      const taxRate = 0.08; // 8% tax
      final taxAmount = subtotal * taxRate;
      const shippingCost = 5.99;
      final totalAmount = subtotal + taxAmount + shippingCost;

      // Create order
      final orderData = {
        'customer_id': customerId,
        'status': 'pending',
        'subtotal': subtotal,
        'tax_amount': taxAmount,
        'discount_amount': 0,
        'shipping_cost': shippingCost,
        'total_amount': totalAmount,
        'shipping_address_line1': shippingAddressLine1,
        'shipping_address_line2': shippingAddressLine2,
        'shipping_city': shippingCity,
        'shipping_state_province': shippingStateProvince,
        'shipping_postal_code': shippingPostalCode,
        'shipping_country': shippingCountry,
        'payment_method': paymentMethod ?? 'credit_card',
        'payment_status': 'pending',
        'notes': notes,
      };

      final orderResponse = await _supabase
          .from(SupabaseConstants.ordersTable)
          .insert(orderData)
          .select()
          .single();

      final orderId = orderResponse['order_id'] as int;

      // Create order items
      final orderItems = items
          .map(
            (item) => {
              'order_id': orderId,
              'product_id': item.productId,
              'quantity': item.quantity,
              'unit_price': item.price,
              'discount_amount': 0,
              'tax_amount': item.totalPrice * taxRate,
              'total_price': item.totalPrice * (1 + taxRate),
            },
          )
          .toList();

      await _supabase
          .from(SupabaseConstants.orderItemsTable)
          .insert(orderItems);

      // Return full order
      return await getOrderById(orderId);
    } catch (e) {
      throw OrderRepositoryException('Failed to create order: $e');
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(int orderId, String status) async {
    try {
      await _supabase
          .from(SupabaseConstants.ordersTable)
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('order_id', orderId);
    } catch (e) {
      throw OrderRepositoryException('Failed to update order status: $e');
    }
  }

  /// Cancel order
  Future<void> cancelOrder(int orderId) async {
    await updateOrderStatus(orderId, 'cancelled');
  }
}

/// Order repository exception
class OrderRepositoryException implements Exception {
  final String message;

  OrderRepositoryException(this.message);

  @override
  String toString() => 'OrderRepositoryException: $message';
}
