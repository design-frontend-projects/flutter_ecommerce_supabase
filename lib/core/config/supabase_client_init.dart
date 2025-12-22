import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientInit {
  static supabaseInit() async {
    return await Supabase.initialize(
      url: 'https://qihgtllyfkoynorwazfn.supabase.co',
      anonKey: 'sb_publishable_OySLUJr1joQ0vyV3WM8GRg_-6SsmwY9',
    );
  }

  static Supabase supabaseInstance() {
    return Supabase.instance;
  }
}
