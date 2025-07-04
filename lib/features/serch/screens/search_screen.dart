import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios)),
        title: const Text("Search your recipe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for recipes, cuisines...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              sectionTitle('Recent Searches', action: 'Clear all'),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: const [
                  Chip(label: Text('Pizza Margherita')),
                  Chip(label: Text('Sushi Roll')),
                  Chip(label: Text('Sushi Set')),
                ],
              ),

              const SizedBox(height: 24),
              sectionTitle('Popular Categories'),
              horizontalList(categories, height: 100),

              const SizedBox(height: 24),
              sectionTitle('Trending Now'),
              horizontalList(trendingItems, height: screenWidth * 0.6),

              const SizedBox(height: 24),
              sectionTitle('Popular Searches'),
              Wrap(
                spacing: 12, runSpacing: 8, direction: Axis.vertical,
                children: const [
                  Text('Chicken Wings', style: TextStyle(fontSize: 16)),
                  Text('Pasta Dishes', style: TextStyle(fontSize: 16)),
                  Text('Vegetarian Options', style: TextStyle(fontSize: 16)),
                  Text('Healthy Bowls', style: TextStyle(fontSize: 16)),
                  Text('Desserts', style: TextStyle(fontSize: 16)),
                ],
              ),

              const SizedBox(height: 24),
              sectionTitle('Suggested For You'),
              horizontalList(suggestedItems, height: screenWidth * 0.6),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable section header
Widget sectionTitle(String title, {String? action}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    if (action?.isNotEmpty ?? false) TextButton(onPressed: () {}, child: Text(action!)),
  ],
);

// Reusable horizontal list
Widget horizontalList(List<Widget> items, {required double height}) => SizedBox(
  height: height,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: items.length,
    separatorBuilder: (_, __) => const SizedBox(width: 12),
    itemBuilder: (_, i) => items[i],
  ),
);

// Category Chip widget
class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const CategoryChip({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
    width: 80,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}

// Food item card builder
Widget foodItemCard({
  required String name, required String restaurant,
  required double rating, required String time, required String image
}) => SizedBox(
  width: 180,
  child: Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 1.5, child: Image.network(image, fit: BoxFit.cover)),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(restaurant, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow[700], size: 16),
              Text(' $rating'),
              const SizedBox(width: 12),
              Icon(Icons.access_time, color: Colors.grey[600], size: 16),
              Text(' $time', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    ),
  ),
);

// Static lists
final categories = const [
  CategoryChip(label: 'Pizza', icon: Icons.local_pizza),
  CategoryChip(label: 'Burgers', icon: Icons.fastfood),
  CategoryChip(label: 'Sushi', icon: Icons.rice_bowl),
  CategoryChip(label: 'Chinese', icon: Icons.food_bank),
];

final trendingItems = [
  foodItemCard(
      name: 'Pepperoni Pizza', restaurant: 'Pizza Palace',
      rating: 4.8, time: '25-30 min',
      image: 'https://i.ibb.co/HfN9KPM8/FRAME-5.png'
  ),
  foodItemCard(
      name: 'Sushi Deluxe', restaurant: 'Sushi House',
      rating: 4.6, time: '20-25 min',
      image: 'https://i.ibb.co/kVLqvGBQ/FRAME-4.png'
  ),
  foodItemCard(
      name: 'Vegan Bowl', restaurant: 'Healthy Bites',
      rating: 4.9, time: '15-20 min',
      image: 'https://i.ibb.co/HfN9KPM8/FRAME-5.png'
  ),
];

final suggestedItems = [
  foodItemCard(
      name: 'Grilled Chicken', restaurant: 'Grill Master',
      rating: 4.7, time: '30-35 min',
      image: 'https://i.ibb.co/HfN9KPM8/FRAME-5.png'
  ),
  foodItemCard(
      name: 'Pasta Carbonara', restaurant: 'Italiano',
      rating: 4.5, time: '20-25 min',
      image: 'https://i.ibb.co/kVLqvGBQ/FRAME-4.png'
  ),
  foodItemCard(
      name: 'Salmon Salad', restaurant: 'Seafood Deli',
      rating: 4.8, time: '15-20 min',
      image: 'https://i.ibb.co/HfN9KPM8/FRAME-5.png'
  ),
];
