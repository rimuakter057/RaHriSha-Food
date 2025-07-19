import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRecipesController extends GetxController {
  final isLoading = true.obs;
  final RxList<dynamic> myRecipes = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyRecipes();
  }

  Future<void> fetchMyRecipes() async {
    try {
      isLoading(true);
      final userId = Supabase.instance.client.auth.currentUser?.id;

      debugPrint('[UserRecipesController] Current user ID: $userId');

      if (userId == null) {
        myRecipes.clear();
        debugPrint('[UserRecipesController] No user ID found!');
        return;
      }

      final response = await Supabase.instance.client
          .from('recipes')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      debugPrint('[UserRecipesController] Fetched recipes: ${response.length}');
      myRecipes.assignAll(response);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch recipes: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteRecipe(int recipeId) async {
    try {
      await Supabase.instance.client
          .from('recipes')
          .delete()
          .eq('id', recipeId);

      debugPrint('[UserRecipesController] Deleted recipe: $recipeId');
      fetchMyRecipes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete recipe: $e');
    }
  }
}
