import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/controller/product_controller.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/product_preview.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [_buildFilterButton()],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.products.isEmpty) {
          return const Center(child: Text('No products found'));
        }
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ListTile(
              leading: product.images.isNotEmpty
                  ? Image.network(
                      product.images.first,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image_not_supported),
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: product.isFavorite ? Colors.red : null,
                ),
                onPressed: () => controller.toggleFavorite(product),
              ),
              onTap: () =>
                  Get.to(() => ProductPreviewScreen(productId: product.id)),
            );
          },
        );
      }),
    );
  }

  Widget _buildFilterButton() {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        // TODO: Open filter dialog (type, price range, tags)
      },
    );
  }
}
