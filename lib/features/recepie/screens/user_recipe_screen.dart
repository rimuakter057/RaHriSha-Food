import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/common/widgets/dialog.dart';
import 'package:rahrisha_food/features/recepie/controller/user_recipe_controller.dart';
import 'package:rahrisha_food/features/recepie/screens/my_recipe_details.dart';

class UserRecipesScreen extends StatelessWidget {
  const UserRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRecipesController());
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'My Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: theme.textTheme.headlineMedium?.fontSize ?? 24,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (controller.myRecipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No recipes yet!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your favorite recipes to get started.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 1000
                ? 3
                : constraints.maxWidth > 600
                ? 2
                : 1;
            double childAspectRatio = constraints.maxWidth > 1000
                ? 1.0
                : constraints.maxWidth > 600
                ? 1.2
                : 1.5;
            double padding = constraints.maxWidth > 1000
                ? 24
                : constraints.maxWidth > 600
                ? 20
                : 16;

            return GridView.builder(
              padding: EdgeInsets.all(padding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.myRecipes.length,
              itemBuilder: (context, index) {
                final recipe = controller.myRecipes[index];
                final imageUrl = recipe['cover_photo_url'] ?? '';
                final category = recipe['category'] ?? '';
                final recipeId = recipe['id'];

                return GestureDetector(
                  onTap: () {
                    if (recipeId != null) {
                      Get.toNamed(MyRecipeDetails.name, arguments: recipeId);
                    }
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 200),
                      tween: Tween(begin: 0.95, end: 1.0),
                      builder: (context, value, child) =>
                          Transform.scale(scale: value, child: child),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        shadowColor: isDarkMode
                            ? Colors.black.withOpacity(0.5)
                            : Colors.orange.withOpacity(0.3),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image section
                                Stack(
                                  children: [
                                    imageUrl.isNotEmpty
                                        ? Image.network(
                                      imageUrl,
                                      height: constraints.maxWidth > 600 ? 200 : 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _buildImagePlaceholder(constraints),
                                    )
                                        : _buildImagePlaceholder(constraints),
                                    Container(
                                      height: constraints.maxWidth > 600 ? 200 : 150,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.7),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    recipe['name'] ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth > 600 ? 20 : 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                      fontFamily: 'RobotoCondensed',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // Delete Button
                            Positioned(
                              top: 10,
                              right: 10,
                              child: _buildDeleteButton(
                                      () => _confirmDelete(controller, recipeId)),
                            ),
                            // Category Badge
                            if (category.isNotEmpty)
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[700],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    category.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  Widget _buildImagePlaceholder(BoxConstraints constraints) {
    return Container(
      height: constraints.maxWidth > 600 ? 200 : 150,
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
    );
  }

  Widget _buildDeleteButton(VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  void _confirmDelete(UserRecipesController controller, int? recipeId) {
    if (recipeId == null) return;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Recipe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              controller.deleteRecipe(recipeId);
              showSuccessDialog(title: 'Recipe Delete',icon: Icons.delete,iconColor: Colors.red, message: ' you successfully delete your recipe',onConfirm: (){
                Get.back();
              });
            },
          ),
        ],
      ),
    );
  }
}
