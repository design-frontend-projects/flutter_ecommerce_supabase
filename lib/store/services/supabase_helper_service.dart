import 'package:flutter_ecommerce_supabase_supabase/core/config/supabase_client_init.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SupabaseHelperService extends GetxService {
  final GetStorage storage = GetStorage();

  supabaseSignout() async{
    try {
      await SupabaseClientInit.supabaseInstance().client.auth.signOut();
      storage.write("isLoggedIn", "false");
      Get.snackbar("Success", "Sign out successfully");
      Get.offAllNamed("/auth/login");
    } catch(e) {
      Get.snackbar("Error", "Logout failed");
    }
  }

}