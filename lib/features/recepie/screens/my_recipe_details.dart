import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/recepie/controller/recipe_detils_controller.dart';
import 'package:rahrisha_food/features/recepie/screens/Edit_recipe.dart';

class MyRecipeDetails extends StatefulWidget {
  static const String name = '/my_recipe_details';

  final int recipeId;

  const MyRecipeDetails({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<MyRecipeDetails> createState() => _MyRecipeDetailsState();
}

class _MyRecipeDetailsState extends State<MyRecipeDetails> {
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
            icon: const Icon(Icons.edit, color: Colors.red),
            onPressed: () {
              Get.to(() => const RecipeEditPage(),
                  arguments: {'recipe': recipeDetailController.recipeDetails});
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

        // Calculate total cooking time in minutes
        int cookingHours = 0;
        int cookingMinutes = 0;
        if (recipe['cooking_hours'] != null) {
          cookingHours = int.tryParse(recipe['cooking_hours'].toString()) ?? 0;
        }
        if (recipe['cooking_minutes'] != null) {
          cookingMinutes = int.tryParse(recipe['cooking_minutes'].toString()) ?? 0;
        }
        final totalCookingMinutes = cookingHours * 60 + cookingMinutes;

        // Ingredients as string list
        List<String> ingredientList = [];
        if (recipe['ingredients'] != null && recipe['ingredients'] is List) {
          final List ingr = recipe['ingredients'];
          ingredientList = ingr.map((e) {
            if (e is Map) {
              final amount = e['amount'] ?? '';
              final unit = e['unit'] ?? '';
              final item = e['item'] ?? '';
              return [amount, unit, item].where((s) => s.toString().isNotEmpty).join(' ');
            }
            return e.toString();
          }).toList();
        }

        // Instructions as string list
        List<String> instructionList = [];
        if (recipe['instructions'] != null && recipe['instructions'] is List) {
          final List ins = recipe['instructions'];
          instructionList = ins.map((e) {
            if (e is Map) {
              return e['description']?.toString() ?? e.toString();
            }
            return e.toString();
          }).toList();
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Cover Photo with rounded corners
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: recipe['cover_photo_url'] != null &&
                    recipe['cover_photo_url'].toString().isNotEmpty
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
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Recipe Name
                    Text(
                      recipe['name'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ✅ Description
                    Text(
                      recipe['description'] ?? 'No description.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ✅ Info Row
                    Row(
                      children: [
                        Icon(Icons.people, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text('${recipe['servings'] ?? 'N/A'} servings'),
                        const SizedBox(width: 16),
                        Icon(Icons.timer, size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(totalCookingMinutes > 0
                            ? '$totalCookingMinutes mins'
                            : 'N/A'),
                        const SizedBox(width: 16),
                        Icon(Icons.leaderboard,
                            size: 20, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(recipe['difficulty'] ?? 'N/A'),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Divider(thickness: 1),

                    // ✅ Ingredients section
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ingredientList.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ingredientList.map(
                            (ing) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.circle,
                                  size: 8, color: Colors.deepOrange),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ing,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                    )
                        : const Text('No ingredients listed.'),

                    const SizedBox(height: 24),
                    Divider(thickness: 1),

                    // ✅ Instructions section
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    instructionList.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: instructionList.asMap().entries.map(
                            (entry) {
                          final index = entry.key + 1;
                          final step = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.check_circle,
                                    size: 18, color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '$step',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    )
                        : const Text('No instructions available.'),
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
