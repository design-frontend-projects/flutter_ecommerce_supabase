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
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  // Stream for employees table
  late final Stream<List<Map<String, dynamic>>> _employeeStream;
  SettingController settingController = Get.put(SettingController());

  @override
  void initState() {
    // getDeviceInfo();
    super.initState();
    // Set up the stream to listen to employees table
    _employeeStream = SupabaseClientInit.supabaseInstance().client
      .from('products')
      .stream(primaryKey: ['product_id'])
      .order('name', ascending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          )),
        actions: [
          IconButton(onPressed: () {
              Get.dialog(AlertDialog(title: Text("are you sure", maxLines: 3,
                    overflow: TextOverflow.ellipsis,), 
                  content: Text("alert content goes here"),
                  contentTextStyle: TextStyle(
                    color: Colors.deepOrange.shade400
                  ),
                  actions: [
                    ElevatedButton(onPressed: () {
                        Get.back(result: "close");
                      }, child: Text("Yes"))
                  ],
                )
              ).then((val) {
                    print(val);
                  });
            }, icon: Icon(Icons.settings)),

        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _employeeStream,
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Handle no data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Rows', style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w400
                ),));
          }

          // Display employee list
          final itemsData = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ItemsModel item = ItemsModel.fromJson(itemsData[index]);
              return Container(
                color: Colors.indigo.shade200,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  children: [
                    Flexible(child: Row(children: [Text("Name: ${item.name} ")],),),
                    Row(children: [Text("Price: ${item.price}")],),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
