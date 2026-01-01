import 'package:flutter_ecommerce_supabase_supabase/models/product.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import 'cart_controller.dart';
import 'favorites_controller.dart';

class ProductController extends GetxController {
  final SupabaseService _supabase = SupabaseService();
  final cartController = Get.find<CartController>();
  final favoritesController = Get.find<FavoritesController>();
  final isLoading = false.obs;

  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    final data = await _supabase.getTable('products');
    if (data != null) {
      products.value = data
          .map((e) => Product.fromMap(e as Map<String, dynamic>))
          .toList();
    }
    isLoading.value = false;
  }

  Product? getProductById(int id) {
    try {
      isLoading.value = true;
      return products.firstWhereOrNull((p) => p.id == id);
    } catch (e) {
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void addToCart(Product product) {
    cartController.addProduct(product);
  }

  void toggleFavorite(Product product) {
    favoritesController.toggleFavorite(product);
  }
}
