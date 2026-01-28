/// Route names for GetX navigation
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String main = '/main';
  static const String home = '/home';
  static const String productDetail = '/product/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetail = '/order/:id';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String profile = '/profile';

  // Admin routes
  static const String adminDashboard = '/admin';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';

  /// Get product detail route
  static String getProductDetail(int id) => '/product/$id';

  /// Get order detail route
  static String getOrderDetail(int id) => '/order/$id';
}
