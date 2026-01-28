import 'package:get/get.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/biometric_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/favorites_controller.dart';

/// Initial binding for app-wide dependencies
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services (already initialized in main.dart)
    Get.lazyPut<SupabaseService>(
      () => Get.find<SupabaseService>(),
      fenix: true,
    );
    Get.lazyPut<StorageService>(() => Get.find<StorageService>(), fenix: true);
    Get.lazyPut<BiometricService>(() => BiometricService(), fenix: true);

    // Global controllers
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<NavigationController>(NavigationController(), permanent: true);
    Get.put<FavoritesController>(FavoritesController(), permanent: true);
  }
}
