import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        backgroundColor: Colors.blueGrey.shade500,
        leading: IconButton(
          onPressed: () {
            Get.offAndToNamed("/");
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          Text("Products here")
        ],
      ),
    );
  }
}
