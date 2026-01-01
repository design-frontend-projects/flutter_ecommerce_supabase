import 'package:flutter_ecommerce_supabase_supabase/core/config/supabase_client_init.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../screens/auth/controller/auth_controller.dart';

class SupabaseHelperService extends GetxService {
  final GetStorage storage = GetStorage();
  final authController = Get.put(AuthController(), permanent: true);

  supabaseSignout() async{
    try {
      await SupabaseClientInit.supabaseInstance().client.auth.signOut();
      storage.write("isLoggedIn", "false");
      Get.snackbar("Success", "Sign out successfully");
      Get.offAllNamed("/auth/login");
      authController.isLoading.value = false;
    } catch(e) {
      Get.snackbar("Error", "Logout failed");
    }
  }

}