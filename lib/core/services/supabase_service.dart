import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';

/// Reusable Supabase service wrapper
class SupabaseService extends GetxService {
  late final SupabaseClient _client;

  SupabaseClient get client => _client;
  GoTrueClient get auth => _client.auth;

  /// Initialize Supabase
  Future<SupabaseService> init() async {
    await Supabase.initialize(
      url: SupabaseConstants.supabaseUrl,
      anonKey: SupabaseConstants.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
    _client = Supabase.instance.client;
    return this;
  }

  /// Get current session
  Session? get currentSession => _client.auth.currentSession;

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw SupabaseException(e.message, code: e.statusCode);
    } catch (e) {
      throw SupabaseException('Sign in failed: $e');
    }
  }

  /// Sign up with email and password
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
    } on AuthException catch (e) {
      throw SupabaseException(e.message, code: e.statusCode);
    } catch (e) {
      throw SupabaseException('Sign up failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw SupabaseException(e.message, code: e.statusCode);
    } catch (e) {
      throw SupabaseException('Sign out failed: $e');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw SupabaseException(e.message, code: e.statusCode);
    } catch (e) {
      throw SupabaseException('Password reset failed: $e');
    }
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Query a table with options
  SupabaseQueryBuilder from(String table) => _client.from(table);

  /// Execute RPC function
  Future<dynamic> rpc(String functionName, {Map<String, dynamic>? params}) {
    return _client.rpc(functionName, params: params);
  }
}

/// Custom exception for Supabase errors
class SupabaseException implements Exception {
  final String message;
  final String? code;

  SupabaseException(this.message, {this.code});

  @override
  String toString() =>
      'SupabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}
