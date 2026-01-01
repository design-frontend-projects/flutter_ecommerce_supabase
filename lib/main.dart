import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_supabase_supabase/screens/auth/login.dart';
import 'package:flutter_ecommerce_supabase_supabase/shared/i18n/app_translations.dart';
import 'package:flutter_ecommerce_supabase_supabase/shared/widgets/layout/onboarding_intro.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'core/config/supabase_client_init.dart';
import 'core/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await SupabaseClientInit.supabaseInit();
  runApp(const MyApp());
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("97758d0f-9e66-4fa8-9d07-aec9efab1b9a");
  OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter ecommerce',
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      translations: AppTranslations(),
      locale: Locale("en"),
      fallbackLocale: Locale("en"),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ),
      initialRoute: "/onboarding",
      getPages: appRoutes,
      home: SafeArea(child: OnboardingIntro()),
    );
  }
}
