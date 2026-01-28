import 'package:get/get.dart';

/// Navigation controller for bottom navigation
class NavigationController extends GetxController {
  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  /// Change current page
  void changePage(int index) {
    _currentIndex.value = index;
  }

  /// Reset to home
  void goToHome() {
    _currentIndex.value = 0;
  }

  /// Go to orders
  void goToOrders() {
    _currentIndex.value = 1;
  }

  /// Go to favorites
  void goToFavorites() {
    _currentIndex.value = 2;
  }

  /// Go to settings
  void goToSettings() {
    _currentIndex.value = 3;
  }
}
