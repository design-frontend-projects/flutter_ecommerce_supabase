import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase_supabase/controllers/product_controller.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ProductController here.
    // The controller will be available to this widget and its children.
    final ProductController productController = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Colors.blueGrey.shade500,
        leading: IconButton(
          onPressed: () {
            Get.offAndToNamed("/");
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product = productController.products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.description),
                trailing: Text("\$${product.price}"),
              );
            },
          );
        }
      }),
    );
  }
}
