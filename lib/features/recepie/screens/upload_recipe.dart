import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/recepie/controller/upload_recipe_controller.dart';

class UploadRecipe extends StatelessWidget {
  const UploadRecipe({super.key});
  static const String name = 'upload';

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
    final UploadRecipeController controller = Get.put(UploadRecipeController());

    final categories = [
      {'title': 'Drink', 'icon': Icons.local_drink},
      {'title': 'Coffee', 'icon': Icons.emoji_food_beverage},
      {'title': 'Fast Food', 'icon': Icons.fastfood_outlined},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'Create Recipe',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Get.defaultDialog(
                title: 'Confirm',
                middleText: 'Are you sure you want to delete this recipe?',
                textConfirm: 'Yes',
                textCancel: 'Cancel',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  controller.deleteRecipe();
                },
              );
            },
          )

        ],
      ),
      body: GetBuilder<UploadRecipeController>(
        builder: (controller) {
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
                          : controller.coverPhotoUrl != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          controller.coverPhotoUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                          : const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Add Cover Photo",
                                style: TextStyle(color: Colors.grey)),
                            Text("Required",
                                style: TextStyle(color: Colors.red, fontSize: 12)),
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
                    final isSelected = controller.selectedCategoryIndex == index;
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
                                color: isSelected ? Colors.deepOrange : Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                            color: isSelected ? Colors.deepOrange : Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item['icon'] as IconData,
                                  color: isSelected ? Colors.white : Colors.black),
                              const SizedBox(width: 4),
                              Text(item['title'] as String,
                                  style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black)),
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
                    const Text('Ingredients', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          child: TextField(
                              controller: ingredient['amount'],
                              decoration: const InputDecoration(hintText: "Amount")),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                              controller: ingredient['unit'],
                              decoration: const InputDecoration(hintText: "Unit")),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                              controller: ingredient['item'],
                              decoration: const InputDecoration(hintText: "Item")),
                        ),
                        IconButton(
                          onPressed: () => controller.removeIngredient(index),
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
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
                    const Text('Instructions', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          decoration: InputDecoration(hintText: "Step ${index + 1}"),
                          maxLines: 2,
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => controller.pickInstructionPhoto(index),
                              icon: const Icon(Icons.image, color: Colors.deepOrange),
                              label: const Text("Add Photo",
                                  style: TextStyle(color: Colors.deepOrange)),
                            ),
                            IconButton(
                              onPressed: () => controller.removeInstruction(index),
                              icon: const Icon(Icons.remove_circle, color: Colors.red),
                            )
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                // Cooking time
                Row(
                  children: [
                    Expanded(
                      child: _labeledField("Hours", "e.g., 1", controller.hoursController,
                          keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _labeledField("Minutes", "e.g., 30", controller.minutesController,
                          keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                _labeledField("Servings", "e.g., 4", controller.servingsController,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                const Text("Difficulty"),
                Wrap(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: controller.easyDifficulty,
                          onChanged: (v) => controller.setDifficulty('Easy'),
                        ),
                        const Text('Easy'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: controller.mediumDifficulty,
                          onChanged: (v) => controller.setDifficulty('Medium'),
                        ),
                        const Text('Medium'),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: controller.hardDifficulty,
                          onChanged: (v) => controller.setDifficulty('Hard'),
                        ),
                        const Text('Hard'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
