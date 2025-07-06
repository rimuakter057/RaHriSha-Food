import 'package:get/get.dart';
import 'package:rahrisha_food/core/widgets/delete_popup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';

class SignInController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> login(String email, String password) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final session = response.session;
      final user = response.user;

      if (session != null && user != null) {
        Get.offAllNamed(MainBottomNavScreen.name);
      } else {
        Get.snackbar('Error', 'Invalid email or password.');
      }
    } on AuthException catch (error) {
      Get.snackbar('Error', error.message);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }

  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
    Get.snackbar('Logged out', 'You have been signed out.');
  }
}
