import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadRecipeController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  // Form Controllers
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController servingsController = TextEditingController();

  File? coverPhoto;
  String? coverPhotoUrl; // For editing
  int selectedCategoryIndex = -1;
  bool easyDifficulty = false;
  bool mediumDifficulty = false;
  bool hardDifficulty = false;

  final List<Map<String, TextEditingController>> ingredients = [];
  final List<Map<String, dynamic>> instructions = [];

  bool isSaving = false;
  int? editingRecipeId;

  @override
  void onInit() {
    super.onInit();
    addIngredient();
    addInstruction();

    final args = Get.arguments;
    if (args != null && args['recipeId'] != null) {
      loadRecipe(args['recipeId']);
    }
  }

  @override
  void onClose() {
    recipeNameController.dispose();
    descriptionController.dispose();
    hoursController.dispose();
    minutesController.dispose();
    servingsController.dispose();
    for (var ing in ingredients) {
      ing['amount']?.dispose();
      ing['unit']?.dispose();
      ing['item']?.dispose();
    }
    for (var ins in instructions) {
      ins['description']?.dispose();
    }
    super.onClose();
  }

  // =================== Pickers ====================
  void pickCoverPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      coverPhoto = File(image.path);
      update();
    }
  }

  void pickInstructionPhoto(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      instructions[index]['photo_url'] = File(image.path);
      update();
    }
  }

  // =================== Helpers ====================
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
      ingredients[index]['amount']?.dispose();
      ingredients[index]['unit']?.dispose();
      ingredients[index]['item']?.dispose();
      ingredients.removeAt(index);
    } else {
      ingredients[index]['amount']?.clear();
      ingredients[index]['unit']?.clear();
      ingredients[index]['item']?.clear();
    }
    update();
  }

  void addInstruction() {
    instructions.add({
      'description': TextEditingController(),
      'photo_url': null,
      'photo_url_string': null,
    });
    update();
  }

  void removeInstruction(int index) {
    if (instructions.length > 1) {
      instructions[index]['description']?.dispose();
      instructions.removeAt(index);
    } else {
      instructions[index]['description']?.clear();
      instructions[index]['photo_url'] = null;
      instructions[index]['photo_url_string'] = null;
    }
    update();
  }

  void setDifficulty(String difficulty) {
    easyDifficulty = difficulty == 'Easy';
    mediumDifficulty = difficulty == 'Medium';
    hardDifficulty = difficulty == 'Hard';
    update();
  }

  String getDifficulty() {
    if (easyDifficulty) return 'Easy';
    if (mediumDifficulty) return 'Medium';
    if (hardDifficulty) return 'Hard';
    return '';
  }

  // =================== Load Recipe ====================
  Future<void> loadRecipe(int recipeId) async {
    editingRecipeId = recipeId;
    isSaving = true;
    update();

    try {
      final recipe = await _supabaseClient
          .from('recipes')
          .select()
          .eq('id', recipeId)
          .single();

      recipeNameController.text = recipe['name'] ?? '';
      descriptionController.text = recipe['description'] ?? '';
      hoursController.text = (recipe['cooking_hours'] ?? '').toString();
      minutesController.text = (recipe['cooking_minutes'] ?? '').toString();
      servingsController.text = (recipe['servings'] ?? '').toString();

      final categories = ['Drink', 'Coffee', 'Fast Food'];
      selectedCategoryIndex = categories.indexOf(recipe['category'] ?? '');

      setDifficulty(recipe['difficulty'] ?? '');
      coverPhotoUrl = recipe['cover_photo_url'];

      // Ingredients
      final ingList = await _supabaseClient
          .from('ingredients')
          .select()
          .eq('recipe_id', recipeId);

      ingredients.clear();
      for (final ing in ingList) {
        ingredients.add({
          'amount': TextEditingController(text: ing['amount'] ?? ''),
          'unit': TextEditingController(text: ing['unit'] ?? ''),
          'item': TextEditingController(text: ing['item'] ?? ''),
        });
      }
      if (ingredients.isEmpty) addIngredient();

      // Instructions
      final insList = await _supabaseClient
          .from('instructions')
          .select()
          .eq('recipe_id', recipeId)
          .order('step_number');

      instructions.clear();
      for (final ins in insList) {
        instructions.add({
          'description': TextEditingController(text: ins['description'] ?? ''),
          'photo_url': null,
          'photo_url_string': ins['photo_url'],
        });
      }
      if (instructions.isEmpty) addInstruction();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load recipe: $e', backgroundColor: Colors.red);
    } finally {
      isSaving = false;
      update();
    }
  }

  // =================== Upload/Update ====================
  Future<void> uploadOrUpdateRecipe() async {
    if (editingRecipeId != null) {
      await updateRecipe();
    } else {
      await uploadRecipe();
    }
  }

  Future<void> uploadRecipe() async {
    isSaving = true;
    update();

    try {
      final String recipeName = recipeNameController.text.trim();
      final String description = descriptionController.text.trim();
      final String category = selectedCategoryIndex != -1
          ? ['Drink', 'Coffee', 'Fast Food'][selectedCategoryIndex]
          : '';
      final int? cookingHours = int.tryParse(hoursController.text.trim());
      final int? cookingMinutes = int.tryParse(minutesController.text.trim());
      final int? servings = int.tryParse(servingsController.text.trim());
      final String difficulty = getDifficulty();

      if (recipeName.isEmpty) {
        Get.snackbar('Error', 'Recipe name is required!', backgroundColor: Colors.red);
        isSaving = false;
        update();
        return;
      }
      if (coverPhoto == null) {
        Get.snackbar('Error', 'Cover photo is required!', backgroundColor: Colors.red);
        isSaving = false;
        update();
        return;
      }

      // Upload cover photo
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${coverPhoto!.path.split('/').last}';
      final String path = 'recipe_photos/$fileName';
      final Uint8List bytes = await coverPhoto!.readAsBytes();

      await _supabaseClient.storage.from('recipe-photos').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );
      final String coverPhotoPublicUrl = _supabaseClient.storage.from('recipe-photos').getPublicUrl(path);

      // Insert recipe
      final insertResponse = await _supabaseClient.from('recipes').insert({
        'name': recipeName,
        'description': description.isEmpty ? null : description,
        'cover_photo_url': coverPhotoPublicUrl,
        'category': category.isEmpty ? null : category,
        'cooking_hours': cookingHours,
        'cooking_minutes': cookingMinutes,
        'servings': servings,
        'difficulty': difficulty.isEmpty ? null : difficulty,
      }).select('id');

      final int recipeId = insertResponse[0]['id'] as int;

      // Insert ingredients
      final ingredientsToInsert = ingredients.map((ing) {
        final amount = ing['amount']?.text.trim() ?? '';
        final unit = ing['unit']?.text.trim() ?? '';
        final item = ing['item']?.text.trim() ?? '';

        if (item.isNotEmpty) {
          return {
            'recipe_id': recipeId,
            'amount': amount.isEmpty ? null : amount,
            'unit': unit.isEmpty ? null : unit,
            'item': item,
          };
        }
        return null;
      }).whereType<Map<String, dynamic>>().toList();

      if (ingredientsToInsert.isNotEmpty) {
        await _supabaseClient.from('ingredients').insert(ingredientsToInsert);
      }

      // Insert instructions
      for (int i = 0; i < instructions.length; i++) {
        final descCtrl = instructions[i]['description'] as TextEditingController;
        final descText = descCtrl.text.trim();
        if (descText.isEmpty) continue;

        String? instructionPhotoUrl;
        final File? photoFile = instructions[i]['photo_url'] as File?;

        if (photoFile != null) {
          final String fileName =
              '${DateTime.now().millisecondsSinceEpoch}_step_${i + 1}_${photoFile.path.split('/').last}';
          final String photoPath = 'instruction_photos/$fileName';
          final Uint8List photoBytes = await photoFile.readAsBytes();

          await _supabaseClient.storage.from('recipe-photos').uploadBinary(
            photoPath,
            photoBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
          instructionPhotoUrl =
              _supabaseClient.storage.from('recipe-photos').getPublicUrl(photoPath);
        }

        await _supabaseClient.from('instructions').insert({
          'recipe_id': recipeId,
          'step_number': i + 1,
          'description': descText,
          'photo_url': instructionPhotoUrl,
        });
      }

      Get.snackbar('Success', 'Recipe uploaded successfully!', backgroundColor: Colors.green);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload recipe: $e', backgroundColor: Colors.red);
    } finally {
      isSaving = false;
      update();
    }
  }
  Future<void> updateRecipe() async {
    if (editingRecipeId == null) return;

    isSaving = true;
    update();

    try {
      final recipeId = editingRecipeId!;
      final String recipeName = recipeNameController.text.trim();
      final String description = descriptionController.text.trim();
      final String category = selectedCategoryIndex != -1
          ? ['Drink', 'Coffee', 'Fast Food'][selectedCategoryIndex]
          : '';
      final int? cookingHours = int.tryParse(hoursController.text.trim());
      final int? cookingMinutes = int.tryParse(minutesController.text.trim());
      final int? servings = int.tryParse(servingsController.text.trim());
      final String difficulty = getDifficulty();

      String? coverPhotoPublicUrl = coverPhotoUrl;
      if (coverPhoto != null) {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${coverPhoto!.path.split('/').last}';
        final String path = 'recipe_photos/$fileName';
        final Uint8List bytes = await coverPhoto!.readAsBytes();

        await _supabaseClient.storage.from('recipe-photos').uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(cacheControl: '3600'),
        );
        coverPhotoPublicUrl = _supabaseClient.storage.from('recipe-photos').getPublicUrl(path);
      }

      final updateData = {
        'name': recipeName,
        'description': description.isEmpty ? null : description,
        'cover_photo_url': coverPhotoPublicUrl,
        'category': category.isEmpty ? null : category,
        'cooking_hours': cookingHours,
        'cooking_minutes': cookingMinutes,
        'servings': servings,
        'difficulty': difficulty.isEmpty ? null : difficulty,
      };

      await _supabaseClient.from('recipes').update(updateData).eq('id', recipeId);

      // Delete old ingredients/instructions
      await _supabaseClient.from('ingredients').delete().eq('recipe_id', recipeId);
      await _supabaseClient.from('instructions').delete().eq('recipe_id', recipeId);

      // Reinsert
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
        final desc = instructions[i]['description'] as TextEditingController;
        if (desc.text.trim().isEmpty) continue;

        String? photoUrl = instructions[i]['photo_url_string'];
        final File? newPhoto = instructions[i]['photo_url'] as File?;

        if (newPhoto != null) {
          final String fileName = '${DateTime.now().millisecondsSinceEpoch}_step_${i + 1}_${newPhoto.path.split('/').last}';
          final String path = 'instruction_photos/$fileName';
          final Uint8List bytes = await newPhoto.readAsBytes();

          await _supabaseClient.storage.from('recipe-photos').uploadBinary(path, bytes);
          photoUrl = _supabaseClient.storage.from('recipe-photos').getPublicUrl(path);
        }

        await _supabaseClient.from('instructions').insert({
          'recipe_id': recipeId,
          'step_number': i + 1,
          'description': desc.text.trim(),
          'photo_url': photoUrl,
        });
      }

      Get.snackbar('Success', 'Recipe updated!', backgroundColor: Colors.green);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update: $e', backgroundColor: Colors.red);
    } finally {
      isSaving = false;
      update();
    }
  }

  // =================== Delete ====================
  Future<void> deleteRecipe() async {
    if (editingRecipeId == null) return;

    try {
      isSaving = true;
      update();

      await _supabaseClient.from('ingredients').delete().eq('recipe_id', editingRecipeId!);
      await _supabaseClient.from('instructions').delete().eq('recipe_id', editingRecipeId!);
      await _supabaseClient.from('recipes').delete().eq('id', editingRecipeId!);

      Get.snackbar('Deleted', 'Recipe deleted.', backgroundColor: Colors.green);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete: $e', backgroundColor: Colors.red);
    } finally {
      isSaving = false;
      update();
    }
  }
}
