import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/cart_controller.dart';
import '../home/home_view.dart';
import '../orders/orders_view.dart';
import '../favorites/favorites_view.dart';
import '../settings/settings_view.dart';
import '../../routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';

/// Main view with bottom navigation
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();
    final authController = Get.find<AuthController>();

    final pages = [
      const HomeView(),
      const OrdersView(),
      const FavoritesView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navigationController.currentIndex,
          children: pages,
        ),
      ),
      floatingActionButton: _buildCartFab(context),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: navigationController.currentIndex,
          onDestinationSelected: navigationController.changePage,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            const NavigationDestination(
              icon: Icon(Icons.favorite_outline),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: authController.isAdmin
                  ? const Icon(Icons.admin_panel_settings_outlined)
                  : const Icon(Icons.settings_outlined),
              selectedIcon: authController.isAdmin
                  ? const Icon(Icons.admin_panel_settings)
                  : const Icon(Icons.settings),
              label: authController.isAdmin ? 'Admin' : 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartFab(BuildContext context) {
    return GetX<CartController>(
      builder: (cartController) {
        if (cartController.isEmpty) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.cart),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: Badge(
            label: Text('${cartController.itemCount}'),
            child: const Icon(Icons.shopping_cart),
          ),
          label: Text('\$${cartController.total.toStringAsFixed(2)}'),
        );
      },
    );
  }
}
