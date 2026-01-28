import 'package:get/get.dart';
import '../controllers/orders_controller.dart';

/// Orders page binding
class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
  }
}
