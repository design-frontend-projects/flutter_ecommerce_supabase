import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/controller/product_controller.dart';
import 'package:get/get.dart';

class ProductPreviewScreen extends StatelessWidget {
  final int productId;

  const ProductPreviewScreen({Key? key, required this.productId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final product = controller.getProductById(productId);
    return Scaffold(
      appBar: AppBar(title: Text(product?.name ?? 'Product')),
      body: product == null
          ? const Center(child: Text('Product not found'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel placeholder
                  Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 100)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  Text(product.description),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => controller.addToCart(product),
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Add to Cart'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => controller.toggleFavorite(product),
                        icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        label: const Text('Favorite'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
