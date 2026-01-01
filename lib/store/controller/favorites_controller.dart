import 'package:flutter_ecommerce_supabase_supabase/models/product.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import 'product_controller.dart';

class FavoritesController extends GetxController {
  final SupabaseService _supabase = SupabaseService();
  var favorites = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final data = await _supabase.getTable('favorites');
    if (data != null) {
      final productIds = (data as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>)["product_id"] as int)
          .toSet();
      final productController = Get.find<ProductController>();
      favorites.value = productController.products
          .where((p) => productIds.contains(p.id))
          .toList();
    }
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      // remove from favorites
      _removeFromSupabase(product.id);
      favorites.remove(product);
    } else {
      // add to favorites
      _addToSupabase(product.id);
      favorites.add(product);
    }
  }

  bool isFavorite(Product product) => favorites.any((p) => p.id == product.id);

  Future<void> _addToSupabase(int productId) async {
    await _supabase.insert('favorites', {'product_id': productId});
  }

  Future<void> _removeFromSupabase(int productId) async {
    await _supabase.delete('favorites', {'product_id': productId});
  }
}
