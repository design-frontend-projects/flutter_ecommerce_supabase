import 'package:get/get.dart';

import '../models/product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // In a real app, you would fetch products from an API or database here
    // For now, we'll just use some dummy data.
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 1));
      var productList = [
        Product(id: 1, name: "Laptop", description: "A cool laptop", price: 999.99, type: "Electronics", tags: ["tech", "computer"], images: []),
        Product(id: 2, name: "Phone", description: "A smart phone", price: 699.99, type: "Electronics", tags: ["tech", "mobile"], images: []),
        Product(id: 3, name: "Book", description: "A great book", price: 19.99, type: "Books", tags: ["reading", "education"], images: []),
      ];
      products.assignAll(productList);
    } finally {
      isLoading(false);
    }
  }
}
