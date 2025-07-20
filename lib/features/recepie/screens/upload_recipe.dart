import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/features/recepie/controller/upload_recipe_controller.dart';

class UploadRecipe extends StatefulWidget { // Changed to StatefulWidget to use initState for loading
  const UploadRecipe({super.key});
  static const String name = 'upload';

  @override
  State<UploadRecipe> createState() => _UploadRecipeState();
}

class _UploadRecipeState extends State<UploadRecipe> {
  late final UploadRecipeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UploadRecipeController());

    // Check if arguments are present and load data if in edit mode
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      controller.loadRecipeData(args);
    } else {
      controller.clearForm(); // ✅ Always fresh for new recipes
    }
  }

  // Keep the labeled field helper method
  Widget _labeledField(
      String label,
      String hint,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType? keyboardType,
      }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              decoration: InputDecoration(hintText: hint),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    // Controller is already initialized in initState

    final categories = [
      {'title': 'Drink', 'icon': Icons.local_drink},
      {'title': 'Coffee', 'icon': Icons.emoji_food_beverage},
      {'title': 'Fast Food', 'icon': Icons.fastfood_outlined},
    ];

    final difficulties = ['Easy', 'Medium', 'Hard'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.editingRecipeId != null ? 'Edit Recipe' : 'Create Recipe', // Dynamic title
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GetBuilder<UploadRecipeController>(
        builder: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover photo picker
                InkWell(
                  onTap: controller.pickCoverPhoto,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: controller.coverPhoto != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          controller.coverPhoto!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                          : controller.coverPhotoUrl != null && controller.coverPhotoUrl!.isNotEmpty // Check for non-empty URL
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          controller.coverPhotoUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text("Image Load Error", style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      )
                          : const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Add Cover Photo",
                                style: TextStyle(color: Colors.grey)),
                            Text("Required",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _labeledField("Recipe Name", "Enter your recipe name",
                    controller.recipeNameController),
                _labeledField("Description", "Tell us about your recipe",
                    controller.descriptionController,
                    maxLines: 3),
                const SizedBox(height: 12),
                const Text("Category"),
                Row(
                  children: List.generate(categories.length, (index) {
                    final isSelected =
                        controller.selectedCategoryIndex == index;
                    final item = categories[index];
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.selectedCategoryIndex = index;
                          controller.update();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isSelected
                                    ? Colors.deepOrange
                                    : Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                            color: isSelected
                                ? Colors.deepOrange
                                : Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item['icon'] as IconData,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black),
                              const SizedBox(width: 4),
                              Text(item['title'] as String,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                // Ingredients
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ingredients',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: controller.addIngredient,
                      icon: const Icon(Icons.add, color: Colors.deepOrange),
                      label: const Text("Add",
                          style: TextStyle(color: Colors.deepOrange)),
                    )
                  ],
                ),
                Column(
                  children: controller.ingredients.asMap().entries.map((entry) {
                    final index = entry.key;
                    final ingredient = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          flex: 2, // Give amount and unit more space
                          child: TextField(
                              controller: ingredient['amount'],
                              decoration:
                              const InputDecoration(hintText: "Amount")),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                              controller: ingredient['unit'],
                              decoration:
                              const InputDecoration(hintText: "Unit")),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 4, // Give item more space
                          child: TextField(
                              controller: ingredient['item'],
                              decoration:
                              const InputDecoration(hintText: "Item")),
                        ),
                        IconButton(
                          onPressed: () => controller.removeIngredient(index),
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Instructions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Instructions',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: controller.addInstruction,
                      icon: const Icon(Icons.add, color: Colors.deepOrange),
                      label: const Text("Add",
                          style: TextStyle(color: Colors.deepOrange)),
                    )
                  ],
                ),
                Column(
                  children: controller.instructions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final instruction = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: instruction['description'],
                          decoration:
                          InputDecoration(hintText: "Step ${index + 1}"),
                          maxLines: 2,
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  controller.pickInstructionPhoto(index),
                              icon: const Icon(Icons.image,
                                  color: Colors.deepOrange),
                              label: const Text("Add Photo",
                                  style: TextStyle(color: Colors.deepOrange)),
                            ),
                            // Show current photo if available
                            if (instruction['photo_url'] != null)
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.file(instruction['photo_url'] as File, fit: BoxFit.cover),
                              ),
                            if (instruction['photo_url'] == null && instruction['photo_url_string'] != null)
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.network(
                                  instruction['photo_url_string'] as String,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                ),
                              ),
                            const Spacer(), // Pushes remove button to the right
                            IconButton(
                              onPressed: () =>
                                  controller.removeInstruction(index),
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                            )
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Cooking time & servings
                Row(
                  children: [
                    Expanded(
                      child: _labeledField(
                          "Hours", "e.g., 1", controller.hoursController,
                          keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _labeledField(
                          "Minutes", "e.g., 30", controller.minutesController,
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                _labeledField("Servings", "e.g., 4",
                    controller.servingsController,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                const Text("Difficulty"),
                Column(
                  children: difficulties.map((difficulty) {
                    return RadioListTile<String>(
                      title: Text(difficulty),
                      value: difficulty,
                      groupValue: controller.getDifficulty(),
                      onChanged: (val) {
                        controller.setDifficulty(val!);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,),
                    onPressed: controller.isSaving
                        ? null
                        : controller.uploadOrUpdateRecipe,
                    child: controller.isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(controller.editingRecipeId != null
                        ? "Update Recipe"
                        : "Publish Recipe"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}