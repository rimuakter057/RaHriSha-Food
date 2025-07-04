import 'package:flutter/material.dart';

class UploadRecipe extends StatefulWidget {
  const UploadRecipe({super.key});

  @override
  State<UploadRecipe> createState() => _UploadRecipeState();
}

class _UploadRecipeState extends State<UploadRecipe> {
  bool _easy = false, _medium = false, _hard = false;
  int selectedIndex = -1;

  final items = [
    {'title': 'Drink', 'icon': Icons.local_drink},
    {'title': 'Coffee', 'icon': Icons.emoji_food_beverage},
    {'title': 'Fast Food', 'icon': Icons.fastfood_outlined},
  ];

  Widget labeledField(String label, String hint, {int maxLines = 1}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
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

  Widget tripleColumn(List<List<String>> fields) => Row(
    children: fields
        .map((col) => Expanded(
      child: Column(
        children: col
            .map((hint) => Padding(
          padding: const EdgeInsets.only(bottom: 6, right: 6),
          child: TextField(decoration: InputDecoration(hintText: hint)),
        ))
            .toList(),
      ),
    ))
        .toList(),
  );

  Widget stepField(int step) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 14, child: Text('$step')),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Step instructions'),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
      ],
    ),
  );

  Widget headerWithAction(String title, String action, VoidCallback onTap) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      TextButton.icon(onPressed: onTap, icon: const Icon(Icons.add), label: Text(action)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Create Recipe'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Save Draft", style: TextStyle(color: Colors.red, fontSize: 18)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            child: SizedBox(
              height: 240,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.grey),
                    Text("Add Cover Photo", style: TextStyle(color: Colors.grey)),
                    Text("Required", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          labeledField("Recipe Name", "Enter Your Recipe Name"),
          const Text("Max 60 characters", style: TextStyle(color: Colors.grey)),
          labeledField("Description", "Tell us about your recipe", maxLines: 2),
          const Text("Share the story behind your recipe", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: List.generate(items.length, (index) {
              final isSelected = selectedIndex == index;
              final item = items[index];
              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => selectedIndex = index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                      color: isSelected ? Colors.deepOrange : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'] as IconData, color: isSelected ? Colors.white : null),
                        const SizedBox(width: 4),
                        Text(
                          item['title'] as String,
                          style: TextStyle(color: isSelected ? Colors.white : null),
                        ),
                      ],
                    )

                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          headerWithAction("Ingredients", "Add Ingredient", () {}),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: tripleColumn([
                ["Amount", "Amount"],
                ["Unit", "Unit"],
                ["Ingredient", "Ingredient"],
              ]),
            ),
          ),
          headerWithAction("Instructions", "Add Step", () {}),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: List.generate(
                  2,
                      (i) => Column(children: [
                    stepField(i + 1),
                    Row(children: const [
                      Icon(Icons.camera_alt, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      Text("Add Photo", style: TextStyle(color: Colors.red)),
                    ]),
                  ]),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text("Cooking Time", style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(child: labeledField("Hours", "")),
              const SizedBox(width: 12),
              Expanded(child: labeledField("Minutes", "")),
            ],
          ),
          const SizedBox(height: 12),
          const Text("Servings"),
          labeledField("Number of servings", ""),
          const SizedBox(height: 12),
          const Text("Difficulty", style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 20,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(value: _easy, onChanged: (v) => setState(() => _easy = v!)),
                  const Text('Easy'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(value: _medium, onChanged: (v) => setState(() => _medium = v!)),
                  const Text('Medium'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(value: _hard, onChanged: (v) => setState(() => _hard = v!)),
                  const Text('Hard'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Selected: ${_easy ? 'Easy ' : ''}${_medium ? 'Medium ' : ''}${_hard ? 'Hard' : ''}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, child: const Text("Publish Recipe")),
          ),
        ]),
      ),
    );
  }
}
