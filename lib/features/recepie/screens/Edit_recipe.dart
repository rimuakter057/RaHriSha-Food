import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeEditPage extends StatelessWidget {
  const RecipeEditPage({super.key});

  Widget _buildLabeledField(String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            maxLines: maxLines,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }

  Widget _buildTripleColumn(List<List<String>> fields) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        fields.length,
            (col) => Expanded(
          child: Column(
            children: List.generate(
              fields[col].length,
                  (row) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: TextField(
                  decoration: InputDecoration(hintText: fields[col][row]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int step, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 14, child: Text('$step')),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              maxLines: 3,
              decoration: InputDecoration(hintText: hint),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        ],
      ),
    );
  }

  Widget _buildHeaderWithAction(String title, String actionText, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        InkWell(
          onTap: onTap,
          child: Row(children: [Icon(Icons.add), Text(actionText)]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Get.back();}, icon: Icon(Icons.arrow_back_ios)),
        title: Text('Edit your recipe'),
        actions: [
          TextButton(onPressed: () {}, child: Text("Cancel", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18))),

        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://i.ibb.co/spKbQv5c/FRAME.png', height: 240, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 8),
            Text("Change Photo", style: TextStyle(color: Colors.grey)),
            _buildLabeledField("Recipe Name", "Healthy Quinoa Bowl!"),
            _buildLabeledField("Description",
                "A nutritious and delicious quinoa bowl packed with fresh vegetables and protein.",
                maxLines: 2),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledField("Prep Time", "20 min"),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildLabeledField("Cook Time", "15 min"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildLabeledField("Serving", "4"),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildLabeledField("Difficulty", "Easy"),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildHeaderWithAction("Ingredients", "Add Ingredient", () {}),
            SizedBox(height: 8),
            _buildTripleColumn([
              ["2 cups", "1", "2 cups"],
              ["Cooked", "Medium", "Mixed"],
              ["Quinoa", "Avocado", "Chopped Vegetable"]
            ]),
            SizedBox(height: 12),
            _buildHeaderWithAction("Instructions", "Add Step", () {}),
            _buildStep(1, 'Rinse quinoa thoroughly and cook according to package instructions.'),
            _buildStep(2, 'Slice avocado and chop vegetables.'),
            _buildStep(3, 'Combine all ingredients in a bowl and season to taste.'),
            SizedBox(height: 12),
            Text("Categories", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Healthy')),
                Chip(label: Text('Vegetarian')),
                Chip(label: Text('Quick and easy')),
              ],
            ),
            SizedBox(height: 12),
            _buildLabeledField("Tags", "lunch, healthy, vegetarian"),
            TextButton(
              onPressed: () {},
              child: Text("Delete Recipe", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
