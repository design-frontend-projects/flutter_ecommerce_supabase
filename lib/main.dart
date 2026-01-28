import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase/presentation/views/splash_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/services/supabase_service.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/routes/app_pages.dart';
import 'presentation/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize services
  final storageService = await StorageService().init();
  Get.put<StorageService>(storageService, permanent: true);

  final supabaseService = SupabaseService();
  await supabaseService.init();
  Get.put<SupabaseService>(supabaseService, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'E-Shop',
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
          defaultTransition: Transition.cupertino,
          home: SplashView(),
        );
      },
    );
  }
}
