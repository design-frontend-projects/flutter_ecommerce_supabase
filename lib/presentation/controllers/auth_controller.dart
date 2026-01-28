import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../routes/app_routes.dart';

/// Authentication controller
class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isLoggedIn => _currentUser.value != null;
  bool get isAdmin => _currentUser.value?.isAdmin ?? false;
  String get userRole => _currentUser.value?.role ?? 'member';
  int? get customerId => _currentUser.value?.customerId;

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  /// Restore user session on app startup
  Future<void> _restoreSession() async {
    _isLoading.value = true;
    try {
      final user = await _authRepository.restoreSession();
      _currentUser.value = user;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({required String email, required String password}) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );

      if (user != null) {
        _currentUser.value = user;
        Get.offAllNamed(AppRoutes.main);
        return true;
      } else {
        _errorMessage.value = 'Invalid email or password';
        return false;
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (user != null) {
        _currentUser.value = user;
        Get.offAllNamed(AppRoutes.main);
        return true;
      } else {
        _errorMessage.value = 'Sign up failed';
        return false;
      }
    } catch (e) {
      _errorMessage.value = e.toString();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading.value = true;
    try {
      await _authRepository.signOut();
      _currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage.value = '';
  }
}
