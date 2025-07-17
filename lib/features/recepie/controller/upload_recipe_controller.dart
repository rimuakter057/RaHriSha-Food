import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rahrisha_food/features/common/widgets/dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadRecipeController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  // === Form Controllers ===
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController servingsController = TextEditingController();

  File? coverPhoto;
  String? coverPhotoUrl; // For editing existing photo url
  int selectedCategoryIndex = -1;

  String? selectedDifficulty; // Easy, Medium, Hard

  final List<Map<String, TextEditingController>> ingredients = [];
  final List<Map<String, dynamic>> instructions = [];

  bool isSaving = false;
  int? editingRecipeId;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    recipeNameController.dispose();
    descriptionController.dispose();
    hoursController.dispose();
    minutesController.dispose();
    servingsController.dispose();

    // Dispose all ingredient controllers
    for (var ing in ingredients) {
      ing.forEach((_, controller) {
        controller.dispose();
      });
    }

    // Dispose all instruction description controllers
    for (var ins in instructions) {
      if (ins['description'] is TextEditingController) {
        (ins['description'] as TextEditingController).dispose();
      }
    }

    super.onClose();
  }

  /// Resets all fields to their initial empty state, suitable for a new recipe.
  void clearForm() {
    recipeNameController.clear();
    descriptionController.clear();
    hoursController.clear();
    minutesController.clear();
    servingsController.clear();

    coverPhoto = null;
    coverPhotoUrl = null;
    selectedCategoryIndex = -1;
    selectedDifficulty = null;
    editingRecipeId = null;

    for (var ing in ingredients) {
      ing.forEach((_, controller) => controller.dispose());
    }
    ingredients.clear();
    addIngredient();

    for (var ins in instructions) {
      if (ins['description'] is TextEditingController) {
        (ins['description'] as TextEditingController).dispose();
      }
    }
    instructions.clear();
    addInstruction();

    isSaving = false;
    update();
  }

  // === Pickers ===
  Future<void> pickCoverPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      coverPhoto = File(image.path);
      coverPhotoUrl = null; // Clear existing URL if a new photo is picked
      update();
    }
  }

  Future<void> pickInstructionPhoto(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      instructions[index]['photo_url'] = File(image.path);
      instructions[index]['photo_url_string'] = null; // clear previous URL if any
      update();
    }
  }

  // === Ingredient Helpers ===
  void addIngredient() {
    ingredients.add({
      'amount': TextEditingController(),
      'unit': TextEditingController(),
      'item': TextEditingController(),
    });
    update();
  }

  void removeIngredient(int index) {
    if (ingredients.length > 1) {
      ingredients[index].forEach((_, controller) {
        controller.dispose();
      });
      ingredients.removeAt(index);
    } else {
      // If only one ingredient left, just clear it instead of removing
      ingredients[index].forEach((_, controller) {
        controller.clear();
      });
      ingredients[index]['amount']?.clear();
      ingredients[index]['unit']?.clear();
      ingredients[index]['item']?.clear();
    }
    update();
  }

  // === Instruction Helpers ===
  void addInstruction() {
    instructions.add({
      'description': TextEditingController(),
      'photo_url': null, // File or null
      'photo_url_string': null, // URL String or null
    });
    update();
  }

  void removeInstruction(int index) {
    if (instructions.length > 1) {
      if (instructions[index]['description'] is TextEditingController) {
        (instructions[index]['description'] as TextEditingController).dispose();
      }
      instructions.removeAt(index);
    } else {
      // If only one instruction left, just clear it instead of removing
      (instructions[index]['description'] as TextEditingController).clear();
      instructions[index]['photo_url'] = null;
      instructions[index]['photo_url_string'] = null;
    }
    update();
  }

  // === Difficulty ===
  void setDifficulty(String difficulty) {
    selectedDifficulty = difficulty;
    update();
  }

  String? getDifficulty() => selectedDifficulty;

  // === Load Existing Recipe Data into Controllers ===
  void loadRecipeData(Map<String, dynamic> data) {
    // First, reset all fields to ensure a clean slate before loading new data
    clearForm();

    recipeNameController.text = data['name'] ?? '';
    descriptionController.text = data['description'] ?? '';

    hoursController.text = (data['cooking_hours'] ?? '').toString();
    minutesController.text = (data['cooking_minutes'] ?? '').toString();
    servingsController.text = (data['servings'] ?? '').toString();

    final categories = ['Drink', 'Coffee', 'Fast Food'];
    selectedCategoryIndex = categories.indexOf(data['category'] ?? '');
    if (selectedCategoryIndex == -1) {
      // Ensure category is reset if not found in list
      selectedCategoryIndex = -1;
    }

    setDifficulty(data['difficulty'] ?? '');

    coverPhotoUrl = data['cover_photo_url'];
    coverPhoto = null; // Existing photo means no new file selected yet

    // Clear and load ingredients
    for (var ing in ingredients) {
      ing.forEach((_, controller) => controller.dispose());
    }
    ingredients.clear();
    if (data['ingredients'] != null && data['ingredients'] is List && (data['ingredients'] as List).isNotEmpty) {
      for (final ing in data['ingredients']) {
        ingredients.add({
          'amount': TextEditingController(text: ing['amount']?.toString() ?? ''),
          'unit': TextEditingController(text: ing['unit']?.toString() ?? ''),
          'item': TextEditingController(text: ing['item']?.toString() ?? ''),
        });
      }
    } else {
      addIngredient(); // Add one if no ingredients
    }

    // Clear and load instructions
    for (var ins in instructions) {
      if (ins['description'] is TextEditingController) {
        (ins['description'] as TextEditingController).dispose();
      }
    }
    instructions.clear();
    if (data['instructions'] != null && data['instructions'] is List && (data['instructions'] as List).isNotEmpty) {
      for (final ins in data['instructions']) {
        instructions.add({
          'description': TextEditingController(text: ins['description']?.toString() ?? ''),
          'photo_url_string': ins['photo_url']?.toString(),
          'photo_url': null, // Existing photo means no new file selected yet
        });
      }
    } else {
      addInstruction(); // Add one if no instructions
    }

    editingRecipeId = data['id'] is int ? data['id'] as int : null;

    update(); // Notify UI after data loading
  }

  // === Upload/Update Recipe ===
  Future<void> uploadOrUpdateRecipe() async {
    // Input validation (consider adding more robust validation here)
    if (recipeNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Recipe name cannot be empty.', backgroundColor: Colors.red);
      return;
    }
    if (coverPhoto == null && coverPhotoUrl == null) {
      Get.snackbar('Error', 'Please add a cover photo.', backgroundColor: Colors.red);
      return;
    }
    if (selectedDifficulty == null) {
      Get.snackbar('Error', 'Please select a difficulty level.', backgroundColor: Colors.red);
      return;
    }
    if (selectedCategoryIndex == -1) {
      Get.snackbar('Error', 'Please select a category.', backgroundColor: Colors.red);
      return;
    }

    // Check if at least one ingredient is filled
    bool hasValidIngredient = ingredients.any((ing) => (ing['item']?.text.trim() ?? '').isNotEmpty);
    if (!hasValidIngredient) {
      Get.snackbar('Error', 'Please add at least one ingredient item.', backgroundColor: Colors.red);
      return;
    }

    // Check if at least one instruction is filled
    bool hasValidInstruction = instructions.any((ins) => (ins['description'] as TextEditingController).text.trim().isNotEmpty);
    if (!hasValidInstruction) {
      Get.snackbar('Error', 'Please add at least one instruction step.', backgroundColor: Colors.red);
      return;
    }


    if (editingRecipeId != null) {
      await _updateRecipe();
    } else {
      await _uploadRecipe();
    }
  }

  Future<void> _uploadRecipe() async {
    isSaving = true;
    update();

    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      final String category = selectedCategoryIndex != -1
          ? ['Drink', 'Coffee', 'Fast Food'][selectedCategoryIndex]
          : '';

      String? coverPhotoPublicUrl;
      if (coverPhoto != null) {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${coverPhoto!.path.split('/').last}';
        final String path = 'recipe_photos/$fileName';
        final Uint8List bytes = await coverPhoto!.readAsBytes();

        await _supabaseClient.storage.from('recipe-photos').uploadBinary(path, bytes,
            fileOptions: const FileOptions(upsert: false)); // Ensure not to overwrite existing
        coverPhotoPublicUrl = _supabaseClient.storage.from('recipe-photos').getPublicUrl(path);
      } else {
        throw 'Cover photo is required for new recipe.'; // Should be caught by validation earlier
      }


      final insertResponse = await _supabaseClient.from('recipes').insert({
        'name': recipeNameController.text.trim(),
        'description': descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
        'cover_photo_url': coverPhotoPublicUrl,
        'category': category.isEmpty ? null : category,
        'cooking_hours': int.tryParse(hoursController.text.trim()),
        'cooking_minutes': int.tryParse(minutesController.text.trim()),
        'servings': int.tryParse(servingsController.text.trim()),
        'difficulty': getDifficulty(),
        'user_id': userId,
      }).select('id');

      final int recipeId = insertResponse[0]['id'] as int;

      final ingredientsToInsert = ingredients.map((ing) {
        final item = ing['item']?.text.trim() ?? '';
        if (item.isNotEmpty) {
          return {
            'recipe_id': recipeId,
            'amount': ing['amount']?.text.trim(),
            'unit': ing['unit']?.text.trim(),
            'item': item,
          };
        }
        return null;
      }).whereType<Map<String, dynamic>>().toList();

      if (ingredientsToInsert.isNotEmpty) {
        await _supabaseClient.from('ingredients').insert(ingredientsToInsert);
      }

      for (int i = 0; i < instructions.length; i++) {
        final descCtrl = instructions[i]['description'] as TextEditingController;
        if (descCtrl.text.trim().isEmpty) continue; // Skip empty instructions

        String? instructionPhotoUrl;
        final File? photoFile = instructions[i]['photo_url'] as File?;

        if (photoFile != null) {
          final String fileName = '${DateTime.now().millisecondsSinceEpoch}_step_${i + 1}_${photoFile.path.split('/').last}';
          final String photoPath = 'instruction_photos/$fileName';
          final Uint8List photoBytes = await photoFile.readAsBytes();

          await _supabaseClient.storage.from('recipe-photos').uploadBinary(photoPath, photoBytes,
              fileOptions: const FileOptions(upsert: false));
          instructionPhotoUrl = _supabaseClient.storage.from('recipe-photos').getPublicUrl(photoPath);
        }

        await _supabaseClient.from('instructions').insert({
          'recipe_id': recipeId,
          'step_number': i + 1,
          'description': descCtrl.text.trim(),
          'photo_url': instructionPhotoUrl,
        });
      }

      showSuccessDialog(title: 'Recipe added', message: ' you successfully add your recipe',onConfirm: (){
        Get.back();
      });
      Get.back();
    } catch (e) {
      showSuccessDialog(title: 'Recipe added', message: ' you successfully add your recipe',onConfirm: (){
        Get.back();
      });
    } finally {
      isSaving = false;
      showSuccessDialog(title: 'Recipe added', message: ' you successfully add your recipe',onConfirm: (){
        Get.back();
      });
      update();
    }
  }

  Future<void> _updateRecipe() async {
    if (editingRecipeId == null) {
      Get.snackbar('Error', 'Recipe ID is missing for update.', backgroundColor: Colors.red);
      return;
    }

    isSaving = true;
    update();

    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      final String category = selectedCategoryIndex != -1
          ? ['Drink', 'Coffee', 'Fast Food'][selectedCategoryIndex]
          : '';

      String? coverPhotoPublicUrl = coverPhotoUrl; // Retain existing URL if no new photo picked
      if (coverPhoto != null) {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${coverPhoto!.path.split('/').last}';
        final String path = 'recipe_photos/$fileName';
        final Uint8List bytes = await coverPhoto!.readAsBytes();

        // Upload new cover photo, potentially overwriting if file name is same (though timestamp makes it unique)
        await _supabaseClient.storage.from('recipe-photos').uploadBinary(path, bytes,
            fileOptions: const FileOptions(upsert: true));
        coverPhotoPublicUrl = _supabaseClient.storage.from('recipe-photos').getPublicUrl(path);
      }

      await _supabaseClient.from('recipes').update({
        'name': recipeNameController.text.trim(),
        'description': descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
        'cover_photo_url': coverPhotoPublicUrl,
        'category': category.isEmpty ? null : category,
        'cooking_hours': int.tryParse(hoursController.text.trim()),
        'cooking_minutes': int.tryParse(minutesController.text.trim()),
        'servings': int.tryParse(servingsController.text.trim()),
        'difficulty': getDifficulty(),
      }).eq('id', editingRecipeId!);

      // Delete existing ingredients and instructions before re-inserting
      await _supabaseClient.from('ingredients').delete().eq('recipe_id', editingRecipeId!);
      await _supabaseClient.from('instructions').delete().eq('recipe_id', editingRecipeId!);

      final ingredientsToInsert = ingredients.map((ing) {
        final item = ing['item']?.text.trim() ?? '';
        if (item.isNotEmpty) { // Only insert if item is not empty
          return {
            'recipe_id': editingRecipeId,
            'amount': ing['amount']?.text.trim(),
            'unit': ing['unit']?.text.trim(),
            'item': item,
          };
        }
        return null;
      }).whereType<Map<String, dynamic>>().toList();

      if (ingredientsToInsert.isNotEmpty) {
        await _supabaseClient.from('ingredients').insert(ingredientsToInsert);
      }

      for (int i = 0; i < instructions.length; i++) {
        final descCtrl = instructions[i]['description'] as TextEditingController;
        if (descCtrl.text.trim().isEmpty) continue; // Skip empty instructions

        String? instructionPhotoUrl = instructions[i]['photo_url_string']; // Retain old URL if no new photo picked
        final File? newPhoto = instructions[i]['photo_url'] as File?;

        if (newPhoto != null) {
          final String fileName = '${DateTime.now().millisecondsSinceEpoch}_step_${i + 1}_${newPhoto.path.split('/').last}';
          final String path = 'instruction_photos/$fileName';
          final Uint8List bytes = await newPhoto.readAsBytes();

          await _supabaseClient.storage.from('recipe-photos').uploadBinary(path, bytes,
              fileOptions: const FileOptions(upsert: true));
          instructionPhotoUrl = _supabaseClient.storage.from('recipe-photos').getPublicUrl(path);
        }

        await _supabaseClient.from('instructions').insert({
          'recipe_id': editingRecipeId,
          'step_number': i + 1,
          'description': descCtrl.text.trim(),
          'photo_url': instructionPhotoUrl,
        });
      }

      showSuccessDialog(title: 'Recipe updated', message: ' you successfully update your recipe',onConfirm: (){
        Get.back();
      });
      Get.back();
    } catch (e) {
      update();
    } finally {
      showSuccessDialog(title: 'Recipe updated', message: ' you successfully update your recipe',onConfirm: (){
        Get.back();
      });
      isSaving = false;
      update();
    }
  }

  Future<void> deleteRecipe(int recipeId) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      isSaving = true;
      update();

      final recipe = await _supabaseClient.from('recipes').select('user_id').eq('id', recipeId).single();
      if (recipe['user_id'] != userId) throw 'You can only delete your own recipes';

      // Delete associated data first
      await _supabaseClient.from('ingredients').delete().eq('recipe_id', recipeId);
      await _supabaseClient.from('instructions').delete().eq('recipe_id', recipeId);
      await _supabaseClient.from('recipes').delete().eq('id', recipeId);

      Get.snackbar('Deleted', 'Recipe deleted.', backgroundColor: Colors.green);
      Get.back(); // Go back after deletion
    } catch (e) {
      Get.snackbar('Error', 'Delete failed: $e', backgroundColor: Colors.red);
    } finally {
      isSaving = false;
      update();
    }
  }
}