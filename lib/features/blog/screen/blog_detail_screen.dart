import 'package:flutter/material.dart';
import 'package:rahrisha_food/app/assets_path.dart';

void main() => runApp(const MaterialApp(home: BlogDetailPage()));

class BlogDetailPage extends StatelessWidget {
  const BlogDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The Art of Making Perfect Homemade Pizza',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(AssetsPath.art, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Text(
                  'By Sarah Mitchell',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 15),
                Text(
                  'March 15, 2024',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 15),
                Text('© 5 min read', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 30),

            const Text(
              'Creating restaurant-quality pizza at home might seem daunting, but with the right techniques and ingredients, '
              'you can master this beloved Italian dish. From achieving the perfect crispy-chewy crust to selecting the finest toppings, '
              'this guide will walk you through every step of the pizza-making process.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 30),

            const Text(
              'The Perfect Dough',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The foundation of any great pizza lies in its dough. The key is using high-quality flour and allowing proper fermentation time. '
              'A good pizza dough needs just four ingredients: flour, water, salt, and yeast. The secret lies in the technique and patience.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 30),

            const Text(
              'Sauce and Toppings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'While traditional Margherita pizza keeps things simple with tomato sauce, fresh mozzarella, and basil, '
              'don\'t be afraid to experiment. The key is balance - avoid overloading your pizza with too many toppings, '
              'which can make the crust soggy.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 30),

            const Text(
              'Baking Techniques',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The secret to a perfectly baked pizza is high heat. While professional pizza ovens can reach temperatures of 800°F or higher, '
              'you can still achieve excellent results in your home oven with the right approach and tools.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 40),

            const Divider(thickness: 1),
            const SizedBox(height: 20),

            const Text(
              'More Food Stories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(AssetsPath.art, height: 150, width: 150),
                      Text('10 Essential Kitchen Tools'),
                      Text('© 7 min read'),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(AssetsPath.art, height: 150, width: 150),
                      Text('10 Essential Kitchen Tools'),
                      Text('© 7 min read'),
                    ],
                  ),
                ),
                SizedBox(width: 16),

                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(AssetsPath.art, height: 150, width: 150),
                      Text('10 Essential Kitchen Tools'),
                      Text('© 7 min read'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
