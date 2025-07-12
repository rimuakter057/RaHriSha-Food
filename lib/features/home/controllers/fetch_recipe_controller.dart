// lib/features/home/controllers/fetch_recipe_controller.dart
import 'dart:async'; // For Timer
import 'package:flutter/material.dart'; // For TextEditingController
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rahrisha_food/features/recepie/screens/recipe_details.dart'; // Import RecipeDetailPage

class HomeController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Lists for displaying recipes (filtered by search if active)
  final RxList<Map<String, dynamic>> displayedFeaturedRecipes = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> displayedAllRecipes = <Map<String, dynamic>>[].obs;

  // Internal lists to hold all fetched data (useful if you want to filter locally without re-fetching)
  final RxList<Map<String, dynamic>> _allFeaturedRecipes = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> _allRawRecipes = <Map<String, dynamic>>[].obs; // For all recipes before processing

  final RxBool isLoadingFeatured = true.obs;
  final RxBool hasErrorFeatured = false.obs;
  final RxString errorMessageFeatured = ''.obs;

  final RxBool isLoadingAllRecipes = true.obs; // Separate loading state for 'All Recipes'
  final RxBool hasErrorAllRecipes = false.obs;
  final RxString errorMessageAllRecipes = ''.obs;
  RxList<Map<String, dynamic>> recipes = <Map<String, dynamic>>[].obs;

  // Search related properties
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs; // To toggle search bar visibility
  Timer? _debounceTimer; // For debouncing search input

  @override
  void onInit() {
    super.onInit();
    print('DEBUG: HomeController onInit called. Starting initial recipe fetch.');
    fetchRecipes(); // Initial fetch for both featured and all recipes
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel timer when controller is closed
    searchController.dispose(); // Dispose the controller
    super.onClose();
  }

  void removeRecipeById(int id) {
    recipes.removeWhere((recipe) => recipe['id'] == id);
    update();
  }
  // Method to toggle search bar visibility
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      // If closing search, clear text and reset results
      searchController.clear();
      _debounceTimer?.cancel(); // Cancel any pending search
      fetchRecipes(); // Re-fetch all recipes when search is cleared
    }
    // Update the AppBar parts specifically
    update(['homeAppBar']); // <--- Specify ID for targeted update
  }

  // Debounced search text change handler
  void onSearchTextChanged(String query) {
    _debounceTimer?.cancel(); // Cancel previous timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Trigger search for both featured and all recipes
      fetchRecipes(searchQuery: query.trim());
    });
  }

  // Unified method to fetch and filter recipes
  Future<void> fetchRecipes({String? searchQuery}) async {
    // Reset states for featured recipes
    isLoadingFeatured.value = true;
    hasErrorFeatured.value = false;
    errorMessageFeatured.value = '';
    displayedFeaturedRecipes.clear();

    // Reset states for all recipes
    isLoadingAllRecipes.value = true;
    hasErrorAllRecipes.value = false;
    errorMessageAllRecipes.value = '';
    displayedAllRecipes.clear();

    // Call update to immediately reflect loading states and clear lists
    update(['featuredRecipes', 'allRecipes']); // Update both lists simultaneously

    print('DEBUG: fetchRecipes started. Search query: "$searchQuery"');

    try {
      // Build the base query
      PostgrestFilterBuilder baseQuery = _supabaseClient
          .from('recipes')
          .select('''
            id,
            name,
            cover_photo_url,
            difficulty,
            servings,
            user_id,
            cooking_hours,
            cooking_minutes,
            description,
            category
          ''');

      // Apply search filter if a query is provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        baseQuery = baseQuery.or(
          'name.ilike.%${searchQuery}%,description.ilike.%${searchQuery}%,category.ilike.%${searchQuery}%',
        );
        // You might want to include more searchable columns like ingredients, instructions if available directly in 'recipes' table or through joins.
      }

      // --- Fetching Featured Recipes ---
      final List<Map<String, dynamic>> featuredResponse = await baseQuery
          .order('created_at', ascending: false) // Order featured by creation date
          .limit(10); // Limit for featured recipes

      final List<Map<String, dynamic>> processedFeatured = featuredResponse.map((recipeData) {
        final Map<String, dynamic> processed = Map<String, dynamic>.from(recipeData);
        processed['id'] = (processed['id'] as num?)?.toInt();
        processed['name'] = processed['name'] as String? ?? 'No Name';
        processed['cover_photo_url'] = processed['cover_photo_url'] as String? ?? '';
        processed['servings'] = processed['servings'] as int? ?? 0;

        final int hours = processed['cooking_hours'] as int? ?? 0;
        final int minutes = processed['cooking_minutes'] as int? ?? 0;
        String timeString = '';
        if (hours > 0) {
          timeString += '${hours} hr ';
        }
        if (minutes > 0) {
          timeString += '${minutes} min';
        }
        processed['time'] = timeString.trim().isNotEmpty ? timeString.trim() : 'N/A';

        processed['average_rating'] = 0.0; // Not fetched, defaulting
        processed['review_count'] = 0;     // Not fetched, defaulting
        processed['restaurant'] = 'N/A';   // Not fetched, defaulting

        return processed;
      }).toList();

      if (searchQuery == null || searchQuery.isEmpty) {
        _allFeaturedRecipes.assignAll(processedFeatured); // Store only if no search
      }
      displayedFeaturedRecipes.assignAll(processedFeatured);
      print('DEBUG: Fetched ${displayedFeaturedRecipes.length} featured recipes for query "$searchQuery".');

      // --- Fetching All Recipes (using the same baseQuery for search) ---
      final List<Map<String, dynamic>> allRecipesResponse = await baseQuery
          .order('name', ascending: true); // Order all recipes alphabetically by name

      final List<Map<String, dynamic>> processedAllRecipes = allRecipesResponse.map((recipeData) {
        final Map<String, dynamic> processed = Map<String, dynamic>.from(recipeData);
        processed['id'] = (processed['id'] as num?)?.toInt();
        processed['name'] = processed['name'] as String? ?? 'No Name';
        processed['cover_photo_url'] = processed['cover_photo_url'] as String? ?? '';
        processed['average_rating'] = (processed['average_rating'] as num?)?.toDouble() ?? 0.0;
        processed['review_count'] = (processed['review_count'] as num?)?.toInt() ?? 0;

        return processed;
      }).toList();

      if (searchQuery == null || searchQuery.isEmpty) {
        _allRawRecipes.assignAll(processedAllRecipes); // Store only if no search
      }
      displayedAllRecipes.assignAll(processedAllRecipes);
      print('DEBUG: Fetched ${displayedAllRecipes.length} all recipes for query "$searchQuery".');

    } on PostgrestException catch (e) {
      hasErrorFeatured.value = true;
      errorMessageFeatured.value = 'Database error fetching featured recipes: ${e.message}';
      hasErrorAllRecipes.value = true;
      errorMessageAllRecipes.value = 'Database error fetching all recipes: ${e.message}';
      print('ERROR: Supabase Postgrest error fetching recipes: ${e.message}');
    } catch (e) {
      hasErrorFeatured.value = true;
      errorMessageFeatured.value = 'An unexpected error occurred fetching featured recipes: ${e.toString()}';
      hasErrorAllRecipes.value = true;
      errorMessageAllRecipes.value = 'An unexpected error occurred fetching all recipes: ${e.toString()}';
      print('ERROR: General error fetching recipes: ${e.toString()}');
    } finally {
      isLoadingFeatured.value = false;
      isLoadingAllRecipes.value = false;
      // Update all relevant GetBuilder IDs
      update(['homeAppBar', 'featuredRecipes', 'allRecipes']);
      print('DEBUG: fetchRecipes completed. isLoadingFeatured: ${isLoadingFeatured.value}, isLoadingAllRecipes: ${isLoadingAllRecipes.value}');
    }
  }

  void navigateToRecipeDetail(int recipeId) {
    Get.toNamed(RecipeDetailPage.name, arguments: recipeId);
  }
}