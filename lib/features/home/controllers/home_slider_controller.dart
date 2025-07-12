import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeCarouselRecipeController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  var carouselRecipes = <Map<String, dynamic>>[].obs; // Reactive list
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessageText = ''.obs;

  var selectedSlider = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCarouselRecipes();
  }

  Future<void> fetchCarouselRecipes() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessageText.value = '';

    try {
      final List<Map<String, dynamic>> response = await _supabaseClient
          .from('recipes')
          .select('id, name, description, cover_photo_url')
          .order('created_at', ascending: false)
          .limit(10);


      final withPublicUrls = response.map((recipe) {
        final path = recipe['cover_photo_url'] ?? '';

        String url;
        if (path.startsWith('http')) {
          url = path;
        } else {
          url = _supabaseClient.storage
              .from('homecarousel')
              .getPublicUrl(path);
        }

        return {
          ...recipe,
          'cover_photo_url': url,
        };
      }).toList();

      carouselRecipes.assignAll(withPublicUrls);
    } catch (e) {
      hasError.value = true;
      errorMessageText.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int index) {
    selectedSlider.value = index;
  }
}
