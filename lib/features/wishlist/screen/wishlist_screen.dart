import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class FavouritesUI {
  Widget favouriteItemCard({
    required String imageUrl,
    required String restaurant,
    required String itemName,
    required String price,
    required double rating,
    required String time,
  });
}

mixin FavouritesUIMixin implements FavouritesUI {
  @override
  Widget favouriteItemCard({
    required String imageUrl,
    required String restaurant,
    required String itemName,
    required String price,
    required double rating,
    required String time,
  }) =>
      SizedBox(
        height: 300,
        child: Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(itemName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                          Row(children: [
                            Icon(Icons.star, color: Colors.amber[700], size: 16),
                            Text(' $rating', style: const TextStyle(fontSize: 12)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                          Text(' $time', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class FavouritesScreen extends StatelessWidget with FavouritesUIMixin {
  FavouritesScreen({super.key});
  static const name = 'favourite-list';
  final List<Map<String, dynamic>> favourites = const [
    {
      'restaurant': 'Pizza Express',
      'itemName': 'Margherita Pizza',
      'price': '\$12.99',
      'rating': 4.8,
      'time': '25-35 min',
    },
    {
      'restaurant': 'Burger House',
      'itemName': 'Classic Cheeseburger',
      'price': '\$8.99',
      'rating': 4.6,
      'time': '20-30 min',
    },
    {
      'restaurant': 'Sushi Master',
      'itemName': 'California Roll',
      'price': '\$15.99',
      'rating': 4.9,
      'time': '30-40 min',
    },
    {
      'restaurant': 'Healthy Bowl',
      'itemName': 'Quinoa Buddha Bowl',
      'price': '\$13.99',
      'rating': 4.7,
      'time': '25-35 min',
    },
  ];

  final List<String> images = [
    'https://i.ibb.co/HfN9KPM8/FRAME-5.png',
    'https://i.ibb.co/kVLqvGBQ/FRAME-4.png',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios)),
      title: const Text(
        'My Favourites',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: favourites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (_, i) {
            final item = favourites[i];
            return favouriteItemCard(
              imageUrl: images[i % images.length],
              restaurant: item['restaurant'],
              itemName: item['itemName'],
              price: item['price'],
              rating: item['rating'],
              time: item['time'],
            );
          },
        ),
      ),
    ),
  );
}
