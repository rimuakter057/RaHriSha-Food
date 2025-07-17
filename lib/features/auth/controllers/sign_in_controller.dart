import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/common/widgets/dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';

class SignInController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> login(String email, String password) async {
    // Basic Validation
    if (email.trim().isEmpty || password.trim().isEmpty) {
      Get.snackbar(
        'Missing Fields',
        'Please fill in both email and password.',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 6 characters long.',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    try {
      // Try login
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user != null && response.session != null) {
        // ✅ Login Success
        showSuccessDialog(
          title: 'Login Successful',
          message: 'Welcome back!',
          onConfirm: () {
            Get.back(); // close dialog
            Get.offAllNamed(MainBottomNavScreen.name); // navigate
          },
        );
      } else {
        // ❌ Login failed — do not navigate
        showSuccessDialog(
          title: 'Login Failed',
          icon: Icons.error_outline,
          iconColor: Colors.red,
          message: 'Invalid email or password. Please try again.',
          onConfirm: () => Get.back(),
        );
      }
    } on AuthException catch (e) {
      // ❌ Login error from Supabase
      showSuccessDialog(
        title: 'Login Error',
        icon: Icons.error,
        iconColor: Colors.red,
        message: e.message,
        onConfirm: () => Get.back(),
      );
    } catch (e) {
      // ❌ Unexpected error
      showSuccessDialog(
        title: 'Unexpected Error',
        icon: Icons.error,
        iconColor: Colors.red,
        message: 'An unexpected error occurred. Please try again later.',
        onConfirm: () => Get.back(),
      );
    }
  }

  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
    showSuccessDialog(
      title: 'Success',
      message: 'You successfully logged out.',
      onConfirm: () => Get.back(),
    );
  }
}
