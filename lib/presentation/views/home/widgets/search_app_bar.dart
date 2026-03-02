import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/cart_controller.dart';
import '../../../routes/app_routes.dart';

/// Search-enabled AppBar for home view
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (homeController.isSearching) {
        return _buildSearchAppBar(context, homeController, isDark);
      }
      return _buildNormalAppBar(context, homeController, isDark);
    });
  }

  Widget _buildGlassmorphicBackground(bool isDark) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: isDark
              ? Colors.black.withAlpha(100)
              : Colors.white.withAlpha(150),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withAlpha(isDark ? 30 : 100),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildNormalAppBar(
    BuildContext context,
    HomeController controller,
    bool isDark,
  ) {
    return AppBar(
      title: const Text(
        'E-Shop',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: _buildGlassmorphicBackground(isDark),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: controller.openSearch,
          tooltip: 'Search products',
        ),
        _CartBadge(),
        const SizedBox(width: 8),
      ],
    );
  }

  AppBar _buildSearchAppBar(
    BuildContext context,
    HomeController controller,
    bool isDark,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: _buildGlassmorphicBackground(isDark),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: controller.closeSearch,
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withAlpha(20)
              : Colors.black.withAlpha(10),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller.searchController,
          autofocus: true,
          onChanged: controller.onSearchChanged,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            isDense: true,
            hintStyle: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
      ),
      actions: [
        Obx(() {
          if (controller.searchQuery.isEmpty) {
            return const SizedBox.shrink();
          }
          return IconButton(
            icon: const Icon(Icons.clear),
            onPressed: controller.clearSearch,
            tooltip: 'Clear search',
          );
        }),
        _CartBadge(),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// Cart icon with badge
class _CartBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<CartController>(
      builder: (cartController) {
        return IconButton(
          icon: Badge(
            isLabelVisible: cartController.itemCount > 0,
            label: Text('${cartController.itemCount}'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          onPressed: () => Get.toNamed(AppRoutes.cart),
          tooltip: 'Cart',
        );
      },
    );
  }
}
