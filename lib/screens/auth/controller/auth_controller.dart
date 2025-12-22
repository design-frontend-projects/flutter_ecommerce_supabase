import 'package:get/get.dart';
import 'package:flutter_ecommerce_supabase_supabase/core/config/supabase_client_init.dart';
import 'package:get_storage/get_storage.dart';
class AuthController extends GetxController {
  final isLoading = false.obs;
  final GetStorage storage = GetStorage();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      var loginRes = await SupabaseClientInit.supabaseInstance().client.auth.signInWithPassword(
        email: email,
        password: password
      );

      // TODO: Implement actual login logic
      await Future.delayed(const Duration(seconds: 2));
      if (loginRes.user != null) {
        print("Login success: $email");
        storage.write("isLoggedIn", "true");
        Get.offAllNamed('/home'); // Navigate to home on success
      }
    } catch (e) {
      storage.write("isLoggedIn", "false");
      Get.snackbar("Error", "Login failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String username, String email, String password) async {
    isLoading.value = true;
    try {
      var registerRes = await SupabaseClientInit.supabaseInstance().client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username
        }
      );
      // TODO: Implement actual register logic
      await Future.delayed(const Duration(seconds: 2));
      print("Register success: $email");
      Get.offAllNamed('/'); // Navigate to home on success
    } catch (e) {
      Get.snackbar("Error", "Registration failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    // TODO: Implement logout logic
    Get.offAllNamed('/auth/login');
  }

  Future<void> sendOtp(String email) async {
    isLoading.value = true;
    try {
      // TODO: Implement send OTP logic
      await Future.delayed(const Duration(seconds: 2));
      print("OTP sent to: $email");
      Get.toNamed('/auth/otp', arguments: {'email': email});
    } catch (e) {
      Get.snackbar("Error", "Failed to send OTP");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String otp) async {
    isLoading.value = true;
    try {
      // TODO: Implement verify OTP logic
      await Future.delayed(const Duration(seconds: 2));
      print("OTP verified: $otp");
      Get.toNamed('/auth/reset-password');
    } catch (e) {
      Get.snackbar("Error", "Invalid OTP");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String newPassword) async {
    isLoading.value = true;
    try {
      // TODO: Implement reset password logic
      await Future.delayed(const Duration(seconds: 2));
      print("Password reset successful");
      Get.offAllNamed('/auth/login');
      Get.snackbar("Success", "Password reset successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to reset password");
    } finally {
      isLoading.value = false;
    }
  }
}
