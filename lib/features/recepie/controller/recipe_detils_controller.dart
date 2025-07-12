import 'package:get/get.dart';
import 'package:rahrisha_food/features/home/controllers/fetch_recipe_controller.dart';
import 'package:rahrisha_food/features/wishlist/controller/favourite_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap recipeDetails = <String, dynamic>{}.obs;

  int? recipeId;

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> fetchRecipeDetails(int id) async {
    isLoading.value = true;
    hasError.value = false;
    recipeId = id; // ✅ Save it here

    try {
      final response = await supabase
          .from('recipes')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        recipeDetails.assignAll(response);
      } else {
        recipeDetails.clear();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load recipe details.';
      recipeDetails.clear();
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteRecipe() async {
    final id = recipeId;
    if (id == null) {
      Get.snackbar('Error', 'No recipe ID.', snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      await supabase.from('recipes').delete().eq('id', id);

      // ✅ Remove from HomeController and FavoriteController too
      final homeController = Get.find<HomeController>();
      final favoriteController = Get.find<FavouritesController>();

      homeController.removeRecipeById(id);
      favoriteController.removeRecipeById(id);

      Get.back();
      update();// Go back after deleting
      Get.snackbar('Deleted', 'Recipe deleted.', snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    }
  }


}
