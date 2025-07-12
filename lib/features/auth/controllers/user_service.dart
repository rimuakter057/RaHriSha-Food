import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService extends GetxController {
  RxString userId = ''.obs; // Add this
  RxString userName = 'No Name'.obs;
  RxString userProfileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      userId.value = user.id; // ✅ Store user ID
      userName.value = user.userMetadata?['name'] ?? user.email ?? 'No Name';

      try {
        final response = await Supabase.instance.client
            .from('users')
            .select('profile_image_url')
            .eq('id', user.id)
            .single();

        userProfileImageUrl.value = response['profile_image_url'] ?? '';
      } catch (e) {
        print('Error fetching user profile image from DB: $e');
        userProfileImageUrl.value = user.userMetadata?['profile_image_url'] ?? '';
      }
    } else {
      // User signed out
      userId.value = '';
      userName.value = 'No Name';
      userProfileImageUrl.value = '';
    }
  }

  void updateLocalProfile({String? name, String? imageUrl}) {
    if (name != null) userName.value = name;
    if (imageUrl != null) userProfileImageUrl.value = imageUrl;
  }
}
