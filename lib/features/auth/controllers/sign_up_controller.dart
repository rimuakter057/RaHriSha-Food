import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,

          data: {
            'name': name,
          },

      );

      if (response.user != null) {
        Get.snackbar('Success', 'Sign up successful!');
        return true;
      } else {
        Get.snackbar('Error', 'Sign up failed.');
        return false;
      }
    } on AuthException catch (e) {
      Get.snackbar('Auth Error', e.message);
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }
}
