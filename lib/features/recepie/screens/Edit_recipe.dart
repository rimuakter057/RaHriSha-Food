import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/recepie/controller/upload_recipe_controller.dart';

class RecipeEditPage extends StatelessWidget {
  const RecipeEditPage({super.key});
  static const String name = 'upload';

  @override
  Widget build(BuildContext context) {
    final UploadRecipeController uploadRecipeController =
    Get.put(UploadRecipeController());

    final Map<String, dynamic>? args = Get.arguments;
    if (args != null && args['recipe'] != null) {
      uploadRecipeController.loadRecipeData(args['recipe']);
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
      ),
      body: GetBuilder<UploadRecipeController>(
        builder: (controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth < 600 ? constraints.maxWidth : 600,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // === Cover Photo ===
                      GestureDetector(
                        onTap: controller.pickCoverPhoto,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: controller.coverPhoto != null
                              ? Image.file(controller.coverPhoto!,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover)
                              : controller.coverPhotoUrl != null
                              ? Image.network(controller.coverPhotoUrl!,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover)
                              : Container(
                            height: 220,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.add_a_photo,
                                size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // === Recipe Name ===
                      _buildTextField(
                        controller: controller.recipeNameController,
                        label: 'Recipe Name',
                        icon: Icons.fastfood,
                      ),
                      const SizedBox(height: 16),

                      // === Description ===
                      _buildTextField(
                        controller: controller.descriptionController,
                        label: 'Description',
                        icon: Icons.description,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // === Cooking Time ===
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: controller.hoursController,
                              label: 'Hours',
                              icon: Icons.timer,
                              inputType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: controller.minutesController,
                              label: 'Minutes',
                              icon: Icons.timer,
                              inputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // === Servings ===
                      _buildTextField(
                        controller: controller.servingsController,
                        label: 'Servings',
                        icon: Icons.people,
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),

                      // === Ingredients ===
                      _buildSectionHeader('Ingredients', controller.addIngredient),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.ingredients.length,
                        itemBuilder: (context, index) {
                          final ing = controller.ingredients[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildSimpleField(
                                      ing['amount']!, 'Amount'),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child:
                                  _buildSimpleField(ing['unit']!, 'Unit'),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildSimpleField(ing['item']!, 'Item'),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      controller.removeIngredient(index),
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // === Instructions ===
                      _buildSectionHeader(
                          'Instructions', controller.addInstruction),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.instructions.length,
                        itemBuilder: (context, index) {
                          final ins = controller.instructions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSimpleField(
                                    ins['description'], 'Step description',
                                    maxLines: 2),
                                const SizedBox(height: 8),
                                if (ins['photo_url_string'] != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      ins['photo_url_string'],
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else if (ins['photo_url'] != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      ins['photo_url'],
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                Row(
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => controller
                                          .pickInstructionPhoto(index),
                                      icon: const Icon(Icons.add_a_photo),
                                      label: const Text('Pick Photo'),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          controller.removeInstruction(index),
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // === Save Button ===
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          onPressed: controller.isSaving
                              ? null
                              : controller.uploadOrUpdateRecipe,
                          icon: controller.isSaving
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                              : const Icon(Icons.save),
                          label: Text(
                              controller.isSaving ? 'Saving...' : 'Update Recipe'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSimpleField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(onPressed: onAdd, icon: const Icon(Icons.add_circle)),
      ],
    );
  }
}
