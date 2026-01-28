import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/routes/app_routes.dart';

/// Middleware to protect admin-only routes
class RoleMiddleware extends GetMiddleware {
  final List<String> allowedRoles;

  RoleMiddleware({required this.allowedRoles});

  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }

    if (!allowedRoles.contains(authController.userRole)) {
      Get.snackbar(
        'Access Denied',
        'You do not have permission to access this page',
        snackPosition: SnackPosition.BOTTOM,
      );
      return const RouteSettings(name: AppRoutes.main);
    }

    return null;
  }
}
