import 'package:flutter_ecommerce_supabase_supabase/models/product.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

class CartController extends GetxController {
  final SupabaseService _supabase = SupabaseService();
  var items = <CartItem>[].obs;

  // Add product to cart or increase quantity if already present
  void addProduct(Product product) {
    final existing = items.firstWhereOrNull((c) => c.product.id == product.id);
    if (existing != null) {
      existing.quantity++;
      items.refresh();
    } else {
      items.add(CartItem(product: product));
    }
    // Optionally sync with Supabase
    _syncCart();
  }

  void removeProduct(Product product) {
    items.removeWhere((c) => c.product.id == product.id);
    _syncCart();
  }

  void updateQuantity(Product product, int quantity) {
    final item = items.firstWhereOrNull((c) => c.product.id == product.id);
    if (item != null) {
      item.quantity = quantity.clamp(1, 99);
      items.refresh();
      _syncCart();
    }
  }

  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.total);

  Future<void> _syncCart() async {
    // Simple placeholder: store cart items in a Supabase table "carts"
    // This implementation assumes a table with columns: user_id, product_id, quantity
    // For brevity, we just ignore errors here.
    // In a real app, you would also handle user authentication.
    // Example:
    // await _supabase.upsert('carts', {...});
  }
}
