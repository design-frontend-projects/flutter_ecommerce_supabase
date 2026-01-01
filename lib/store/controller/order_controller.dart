import 'package:flutter_ecommerce_supabase_supabase/models/order.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  final SupabaseService _supabase = SupabaseService();
  final cartController = Get.find<CartController>();

  var orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final data = await _supabase.getTable('orders');
    if (data != null) {
      orders.value = data
          .map((e) => Order.fromMap(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> createOrder({
    required String address,
    required double total,
  }) async {
    // Simplified order creation, assuming user_id is handled elsewhere
    final orderData = {
      'address': address,
      'total': total,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    };
    final success = await _supabase.insert('orders', orderData);
    if (success) {
      await fetchOrders();
      // Clear cart after successful order
      cartController.items.clear();
    }
  }
}
