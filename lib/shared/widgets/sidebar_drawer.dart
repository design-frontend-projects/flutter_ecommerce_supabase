import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/controller/SettingController.dart';
import 'package:flutter_ecommerce_supabase_supabase/store/services/supabase_helper_service.dart';
import 'package:get/get.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // final storage = GetStorage();
    final settingControl = Get.put(SettingController(), permanent: true);
    final supabaseHelper = Get.put(SupabaseHelperService(), permanent: true);

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amberAccent[50],
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.blue[200],
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text("Welcome, Ahmed mohamed"),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CircleAvatar(maxRadius: 30, child: Text("AA")),
                  )
                ],
              ),
            )),
          ListTile(
            leading: const Icon(
              Icons.home,
            ),
            title: const Text('home'),
            onTap: () {
              Get.toNamed("/");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person_2_rounded,
            ),
            title: const Text('Aboutus'),
            onTap: () {
              Get.offAndToNamed("/aboutus");
            },
          ),
          ListTile(
            leading: Obx(() => Switch(
                value: settingControl.themeState.value,
                onChanged: (val) {
                  settingControl.toggleThemeMode();
                },
              )),
            title: const Text('Dark Mode'),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Signout'),
            onTap: () {
              supabaseHelper.supabaseSignout();
            },
          ),
        ],
      ));
  }
}
