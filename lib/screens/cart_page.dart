import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/controller/cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartCtrl = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Obx(() {
        if (cartCtrl.items.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }
        return ListView.builder(
          itemCount: cartCtrl.items.length,
          itemBuilder: (context, index) {
            final item = cartCtrl.items[index];
            return ListTile(
              leading: Image.network(
                item.product.images.isNotEmpty ? item.product.images.first : '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item.product.name),
              subtitle: Text(
                'Qty: ${item.quantity} – \$${(item.product.price * item.quantity).toStringAsFixed(2)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => cartCtrl.removeProduct(item.product),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: const Text('Proceed to Checkout'),
          onPressed: () => Get.toNamed('/checkout'),
        ),
      ),
    );
  }
}
