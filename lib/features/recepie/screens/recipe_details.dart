import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _detailsKey = GlobalKey();
  final GlobalKey _ingredientsKey = GlobalKey();
  final GlobalKey _instructionsKey = GlobalKey();
  final GlobalKey _nutritionKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              key: _detailsKey,
              height: 240,
              width: double.infinity,
              child: Image.network(
                'https://i.ibb.co/xqsjt73P/FRAME-1.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Homemade Classic Margherita Pizza',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.person)),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sarah Mitchell',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  'Professional Chef',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTimeInfo(
                            'Time',
                            '15 min',
                            Icons.watch_later_outlined,
                          ),
                          _buildTimeInfo('Servings', '4', Icons.people_outline),
                          _buildTimeInfo(
                            'Difficulty',
                            'Medium',
                            Icons.assessment,
                          ),
                          _buildTimeInfo('Rating', '4.8', Icons.star_border),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 4,
                    children: [
                      TextButton(
                        onPressed: () => _scrollToSection(_detailsKey),
                        child: const Text('Details'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_ingredientsKey),
                        child: const Text('Ingredients'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_instructionsKey),
                        child: const Text('Instructions'),
                      ),
                      TextButton(
                        onPressed: () => _scrollToSection(_nutritionKey),
                        child: const Text('Nutrition'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A classic Neapolitan pizza with fresh mozzarella, basil, and San Marzano tomatoes. Perfect for pizza lovers who want to master the art of homemade pizza.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTimeInfo(
                                'Preparation Time',
                                '15 minutes',
                                null,
                              ),
                              _buildTimeInfo(
                                'Cooking Time',
                                '20 minutes',
                                null,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildTimeInfo('Total Time', '35 min', null),
                              _buildTimeInfo('Servings', '4 portions', null),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryChip('Italian'),
                      _buildCategoryChip('Main Course'),
                      _buildCategoryChip('Vegetarian'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Ingredients', key: _ingredientsKey),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _ingredients.map(_buildIngredientItem).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Instructions', key: _instructionsKey),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: List.generate(
                        _instructions.length,
                        (index) => _buildInstructionStep(
                          index + 1,
                          _instructions[index],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Nutrition Facts', key: _nutritionKey),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildNutritionItem('Calories', '285'),
                              _buildNutritionItem('Protein', '12g'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildNutritionItem('Carbs', '42g'),
                              _buildNutritionItem('Fat', '8g'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildNutritionItem('Fiber', '2g'),
                              _buildNutritionItem('Sodium', '590mg'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String value, IconData? icon) {
    return Expanded(
      child: Column(
        children: [
          if (icon != null) Icon(icon, size: 24, color: Colors.blue),
          if (icon != null) const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey.shade100,
      labelStyle: const TextStyle(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
    );
  }

  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(int step, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.blue,
            child: Text('$step', style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(instruction, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  static const _instructions = [
    'Mix flour, yeast, and salt in a large bowl',
    'Add warm water and olive oil, knead until smooth',
    'Let dough rise for 1 hour',
    'Preheat oven to 450°F (230°C)',
    'Roll out dough and add toppings',
    'Bake for 15-20 minutes until crust is golden',
  ];

  static const _ingredients = [
    '3 cups (375g) all-purpose flour',
    '1 tsp instant yeast',
    '1 tsp salt',
    '1 cup warm water',
    '2 tbsp olive oil',
    '4 San Marzano tomatoes',
    '8 oz fresh mozzarella',
    'Fresh basil leaves',
    'Extra virgin olive oil for drizzling',
  ];
}
