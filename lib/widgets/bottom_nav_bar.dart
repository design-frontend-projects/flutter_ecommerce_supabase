import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  final List<_NavItem> _items = const [
    _NavItem(label: 'Home', icon: Icons.home, route: '/'),
    _NavItem(label: 'Products', icon: Icons.shopping_bag, route: '/products'),
    _NavItem(label: 'Cart', icon: Icons.shopping_cart, route: '/cart'),
    _NavItem(label: 'Orders', icon: Icons.receipt_long, route: '/orders'),
    _NavItem(label: 'Profile', icon: Icons.person, route: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final current = Get.currentRoute;
    int currentIndex = _items.indexWhere((e) => e.route == current);
    if (currentIndex == -1) currentIndex = 0;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: _items
          .map(
            (e) => BottomNavigationBarItem(icon: Icon(e.icon), label: e.label),
          )
          .toList(),
      currentIndex: currentIndex,
      onTap: (index) {
        final target = _items[index].route;
        if (target != current) {
          Get.offAllNamed(target);
        }
      },
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}
