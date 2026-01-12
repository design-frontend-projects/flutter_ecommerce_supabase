import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase_supabase/core/config/supabase_client_init.dart';
import 'package:flutter_ecommerce_supabase_supabase/core/models/ItemsModel.dart';
import 'package:flutter_ecommerce_supabase_supabase/shared/widgets/sidebar_drawer.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/controller/SettingController.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          )),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(AlertDialog(
                  title: const Text(
                    "are you sure",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  content: const Text("alert content goes here"),
                  contentTextStyle:
                  TextStyle(color: Colors.deepOrange.shade400),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back(result: "close");
                      },
                      child: const Text("Yes"))
                  ],
                )).then((val) {
                    print(val);
                  });
            },
            icon: const Icon(Icons.settings)),
        ],
      ),
      body: Column(
        children: [
          Text("Hello wold")
        ],
      )
    );
  }
}
