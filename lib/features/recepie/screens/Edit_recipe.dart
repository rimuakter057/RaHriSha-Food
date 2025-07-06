import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/core/widgets/delete_popup.dart';

class RecipeEditPage extends StatelessWidget {
  const RecipeEditPage({super.key});
  static const String name='edit';
  Widget labeledField(String label, String hint, {int maxLines = 1}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    ),
  );

  Widget tripleColumn(List<List<String>> fields) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(
      fields.length,
          (col) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: col != fields.length - 1 ? 12 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fields[col]
                .map((hint) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: hint,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                ),
              ),
            ))
                .toList(),
          ),
        ),
      ),
    ),
  );

  Widget stepField(int step, String hint) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 14, child: Text('$step')),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(maxLines: 3, decoration: InputDecoration(hintText: hint)),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ],
    ),
  );

  Widget headerWithAction(String title, String actionText, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        InkWell(
          onTap: onTap,
          child: Row(children: [const Icon(Icons.add), Text(actionText)]),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final hp = w < 500 ? 16.0 : w * 0.1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios)),
        title: const Text('Edit your recipe'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Cancel",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hp, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://i.ibb.co/spKbQv5c/FRAME.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Change Photo", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            labeledField("Recipe Name", "Healthy Quinoa Bowl!"),
            labeledField(
              "Description",
              "A nutritious and delicious quinoa bowl packed with fresh vegetables and protein.",
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: labeledField("Prep Time", "20 min")),
                const SizedBox(width: 12),
                Expanded(child: labeledField("Cook Time", "15 min")),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: labeledField("Serving", "4")),
                const SizedBox(width: 12),
                Expanded(child: labeledField("Difficulty", "Easy")),
              ],
            ),
            const SizedBox(height: 20),
            headerWithAction("Ingredients", "Add Ingredient", () {}),
            const SizedBox(height: 8),
            tripleColumn([
              ["2 cups", "1", "2 cups"],
              ["Cooked", "Medium", "Mixed"],
              ["Quinoa", "Avocado", "Chopped Vegetable"]
            ]),
            const SizedBox(height: 20),
            headerWithAction("Instructions", "Add Step", () {}),
            stepField(1, 'Rinse quinoa thoroughly and cook according to package instructions.'),
            stepField(2, 'Slice avocado and chop vegetables.'),
            stepField(3, 'Combine all ingredients in a bowl and season to taste.'),
            const SizedBox(height: 20),
            const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Healthy')),
                Chip(label: Text('Vegetarian')),
                Chip(label: Text('Quick and easy')),
              ],
            ),
            const SizedBox(height: 20),
            labeledField("Tags", "lunch, healthy, vegetarian"),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  showConfirmDeleteDialog(
                    context: context,
                    icon:Icons.warning_amber_rounded,
                    title: 'Delete Recipe?',
                    message:
                    'Are you sure you want to permanently delete this recipe? This action cannot be undone.',
                    onConfirm: () {},
                  );
                },
                child: const Text("Delete Recipe",
                    style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
