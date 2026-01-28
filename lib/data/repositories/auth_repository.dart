import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/supabase_service.dart';
import '../models/user_model.dart';

/// Repository for authentication operations
class AuthRepository {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final StorageService _storage = Get.find<StorageService>();

  /// Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabase.signInWithEmail(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw AuthRepositoryException('Sign in failed: No user returned');
      }

      // Fetch customer profile
      final customer = await _getCustomerByEmail(email);
      if (customer != null) {
        await _cacheUser(customer);
        return customer;
      }

      return null;
    } catch (e) {
      throw AuthRepositoryException('Sign in failed: $e');
    }
  }

  /// Sign up with email and password
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final authResponse = await _supabase.signUpWithEmail(
        email: email,
        password: password,
        metadata: {'first_name': firstName, 'last_name': lastName},
      );

      if (authResponse.user == null) {
        throw AuthRepositoryException('Sign up failed: No user returned');
      }

      // Create customer profile
      final customerData = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'role': SupabaseConstants.roleMember,
      };

      final response = await _supabase
          .from(SupabaseConstants.customersTable)
          .insert(customerData)
          .select()
          .single();

      final customer = UserModel.fromJson(response);
      await _cacheUser(customer);
      return customer;
    } catch (e) {
      throw AuthRepositoryException('Sign up failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.signOut();
      await _clearCachedUser();
    } catch (e) {
      throw AuthRepositoryException('Sign out failed: $e');
    }
  }

  /// Get current user from cache
  UserModel? getCachedUser() {
    final userData = _storage.readJson(AppConstants.userKey);
    if (userData == null) return null;
    return UserModel.fromJson(userData);
  }

  /// Get current user role from cache
  String? getCachedRole() {
    return _storage.read<String>(AppConstants.roleKey);
  }

  /// Restore session on app startup
  Future<UserModel?> restoreSession() async {
    if (!_supabase.isAuthenticated) {
      await _clearCachedUser();
      return null;
    }

    // Try to get cached user first
    final cachedUser = getCachedUser();
    if (cachedUser != null) {
      return cachedUser;
    }

    // Fetch from database
    final email = _supabase.currentUser?.email;
    if (email == null) return null;

    final customer = await _getCustomerByEmail(email);
    if (customer != null) {
      await _cacheUser(customer);
      return customer;
    }

    return null;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _supabase.isAuthenticated;

  /// Get customer by email
  Future<UserModel?> _getCustomerByEmail(String email) async {
    try {
      final response = await _supabase
          .from(SupabaseConstants.customersTable)
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Cache user data locally
  Future<void> _cacheUser(UserModel user) async {
    await _storage.writeJson(AppConstants.userKey, user.toJson());
    await _storage.write(AppConstants.roleKey, user.role);
  }

  /// Clear cached user data
  Future<void> _clearCachedUser() async {
    await _storage.remove(AppConstants.userKey);
    await _storage.remove(AppConstants.roleKey);
  }
}

/// Auth repository exception
class AuthRepositoryException implements Exception {
  final String message;

  AuthRepositoryException(this.message);

  @override
  String toString() => 'AuthRepositoryException: $message';
}
