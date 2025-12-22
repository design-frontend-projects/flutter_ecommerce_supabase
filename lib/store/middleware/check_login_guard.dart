import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CheckLoginGuard extends GetMiddleware {
  @override
  int get priority => 1;
  final GetStorage storage = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    // Read the value from storage
    // If it's stored as "true" or "false" (strings)
    final String? isLoggedIn = storage.read('isLoggedIn');
    
    // If it is stored as boolean in some places (safety check), try to read as dynamic
    final dynamic rawValue = storage.read('isLoggedIn');
    
    bool isLogin = false;

    if (rawValue is bool) {
      isLogin = rawValue;
    } else if (rawValue is String) {
      isLogin = rawValue == 'true';
    }

    print("is logged in *****: $isLogin");
    
    // If the user is not logged in, redirect to login page
    // BUT avoid redirecting if we are already going to the login page or auth pages
    // to prevent loops if this middleware is applied globally or incorrectly.
    // However, usually this middleware is applied to protected routes like '/home'.
    
    if (!isLogin) {
       return const RouteSettings(name: '/auth/login');
    }
    
    return null;
  }

  @override
  Widget onPageBuilt(Widget page) {
    return page;
  }

  @override
  void onPageDispose() {
    print('PageDisposed');
  }
}
