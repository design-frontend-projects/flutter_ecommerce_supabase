import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CheckLoginGuard extends GetMiddleware {
  // @override
  // int get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.put(AuthController(), permanent: true);
    final GetStorage storage = GetStorage();

    // Read the value from storage
    // Handle potential different types (bool, string, null)
    final dynamic rawValue = storage.read('isLoggedIn');
    bool isLogin = false;

    if (rawValue is bool) {
      isLogin = rawValue;
    } else if (rawValue is String) {
      isLogin = rawValue == 'true';
    }
    print("CheckLoginGuard: route: $route, isLoggedIn: $isLogin");

    // Allow access to auth routes
    if (route != null && (route == '/auth/login' || route.startsWith('/auth/'))) {
      return null;
    } else {
      // If not logged in, redirect to auth/login
      if (!isLogin || !authController.isLoading.value) {
        print("***** User not logged in ($isLogin). Redirecting to /auth/login");
        return RouteSettings(name: '/auth/login');
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    // Log navigation attempts for security auditing
    print("page called: ${page!.name} + ${page.page}");
    return page;
  }
}
