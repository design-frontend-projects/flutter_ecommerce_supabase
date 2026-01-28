/// Supabase configuration constants
class SupabaseConstants {
  SupabaseConstants._();

  // Supabase credentials - loaded from environment
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://qihgtllyfkoynorwazfn.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_C5OoeQS55VAsDo0qMw6z3Q_G6DG2F7m',
  );

  // Table Names
  static const String productsTable = 'products';
  static const String categoriesTable = 'categories';
  static const String customersTable = 'customers';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String favoritesTable = 'favorites';
  static const String suppliersTable = 'suppliers';
  static const String inventoryTable = 'inventory';

  // User Roles
  static const String roleMember = 'member';
  static const String roleAdmin = 'admin';
}
