import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/recepie/controller/recipe_detils_controller.dart';

class RecipeDetailPage extends StatefulWidget {
  static const String name = '/recipe-details';

  final int recipeId;

  const RecipeDetailPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final RecipeDetailController recipeDetailController = Get.find();

  @override
  void initState() {
    super.initState();
    recipeDetailController.fetchRecipeDetails(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Get.defaultDialog(
                title: 'Confirm Delete',
                middleText: 'Are you sure you want to delete this recipe?',
                textConfirm: 'Yes',
                textCancel: 'Cancel',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  Get.back();
                  recipeDetailController.deleteRecipe();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (recipeDetailController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (recipeDetailController.hasError.value) {
          return Center(child: Text(recipeDetailController.errorMessage.value));
        }
        if (recipeDetailController.recipeDetails.isEmpty) {
          return const Center(child: Text('No details found.'));
        }

        final recipe = recipeDetailController.recipeDetails;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Cover Photo
              recipe['cover_photo_url'] != null && recipe['cover_photo_url'].toString().isNotEmpty
                  ? Image.network(
                recipe['cover_photo_url'],
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
                  : Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 100, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Name
                    Text(
                      recipe['name'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Recipe Description
                    Text(
                      recipe['description'] ?? 'No description.',
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 16),

                    // Info Row
                    Row(
                      children: [
                        Icon(Icons.people, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text('${recipe['servings'] ?? 'N/A'} servings'),
                        const SizedBox(width: 16),
                        Icon(Icons.timer, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text('${recipe['cooking_time'] ?? 'N/A'} mins'),
                        const SizedBox(width: 16),
                        Icon(Icons.leaderboard, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text('${recipe['difficulty'] ?? 'N/A'}'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Ingredients
                    const Text(
                      'Ingredients',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (recipe['ingredients'] != null && recipe['ingredients'] is List)
                      ...List<Widget>.from(
                        (recipe['ingredients'] as List).map(
                              (ingredient) => Text('• ${ingredient.toString()}'),
                        ),
                      )
                    else
                      const Text('No ingredients listed.'),

                    const SizedBox(height: 24),

                    // Instructions
                    const Text(
                      'Instructions',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (recipe['instructions'] != null && recipe['instructions'] is List)
                      ...List<Widget>.from(
                        (recipe['instructions'] as List).map(
                              (step) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text('• ${step.toString()}'),
                          ),
                        ),
                      )
                    else
                      const Text('No instructions available.'),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
