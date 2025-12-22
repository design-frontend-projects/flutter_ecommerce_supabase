import 'package:flutter_ecommerce_supabase_supabase/shared/i18n/ar.dart';
import 'package:flutter_ecommerce_supabase_supabase/shared/i18n/en.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': EnglishLang.englishWords,
    'ar': ArabicLang.arabicWords
  };
}