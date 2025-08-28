import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appchatfl/services/auth_service.dart';
import 'package:appchatfl/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Reactive variables
  final Rx<User?> _user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters
  User? get user => _user.value;
  bool get isLoggedIn => _user.value != null;

  @override
  void onInit() {
    super.onInit();
    // Listen to authentication state changes
    _authService.authStateChanges.listen((User? user) {
      _user.value = user;
    });
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.signInWithEmailAndPassword(email, password);

      // Navigate to home after successful login
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Login Failed', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword(
      String email, String password, String fullName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.registerWithEmailAndPassword(email, password, fullName);

      // Navigate to home after successful registration
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Registration Failed', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.signInWithGoogle();

      // Navigate to home after successful login
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Google Sign-In Failed', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.signOut();

      // Navigate to login after sign out
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Sign Out Failed', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.resetPassword(email);

      Get.snackbar('Success', 'Password reset email sent',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Password Reset Failed', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
    String? status,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
        status: status,
      );

      Get.snackbar('Success', 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Profile Update Failed', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }
}