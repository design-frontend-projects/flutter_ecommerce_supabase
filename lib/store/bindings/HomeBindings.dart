import 'package:flutter_ecommerce_supabase_supabase/store/controller/SettingController.dart';
import 'package:get/get.dart';
class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController(),tag: "settingController");
  }

}