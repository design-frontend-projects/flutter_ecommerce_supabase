import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/cart_controller.dart';
import '../../../../core/theme/app_colors.dart';
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
      return _buildNormalAppBar(context, homeController);
    });
  }

  AppBar _buildNormalAppBar(BuildContext context, HomeController controller) {
    return AppBar(
      title: const Text('E-Shop'),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: controller.openSearch,
          tooltip: 'Search products',
        ),
        _CartBadge(),
      ],
    );
  }

  AppBar _buildSearchAppBar(
    BuildContext context,
    HomeController controller,
    bool isDark,
  ) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: controller.closeSearch,
      ),
      title: TextField(
        controller: controller.searchController,
        autofocus: true,
        onChanged: controller.onSearchChanged,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search products...',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
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
