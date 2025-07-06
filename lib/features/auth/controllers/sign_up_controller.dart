import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      return response.user != null; // Success if user is created
    } on AuthException catch (e) {
      Get.snackbar('Error', e.message);
      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }


}
