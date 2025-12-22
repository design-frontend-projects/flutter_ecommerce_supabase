import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
class SettingController extends GetxController {
  RxInt counter = 0.obs;
  GetStorage storage = GetStorage();
  late RxString defaultLocale = (storage.read("APP_LANG") ?? 'ar'.obs);
  final RxBool themeState = false.obs;

  void toggleThemeMode() {
    themeState.trigger(themeState.value == true ? false : true);
    Get.changeTheme(themeState.value == true
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true));
  }

  void increment() {
    counter++;
  }

  void decrement() {
    counter--;
  }

  void changeLanguage(String langCode) {
    Locale locale;

    if (langCode == 'ar') {
      storage.write("APP_LANG", 'ar');
      defaultLocale.value = 'ar';
      locale = const Locale('ar', 'SA');
    } else {
      storage.write("APP_LANG", 'en');
      defaultLocale.value = 'en';
      locale = const Locale('en', 'US');
    }

    Get.updateLocale(locale);
  }
}