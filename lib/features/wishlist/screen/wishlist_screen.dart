import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final images = [
      'https://i.ibb.co/HfN9KPM8/FRAME-5.png',
      'https://i.ibb.co/kVLqvGBQ/FRAME-4.png',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios)),
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
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: favourites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72, // Adjust for no overflow
            ),
            itemBuilder: (context, index) {
              final item = favourites[index];
              final imageUrl = images[index % 2];
              return favouriteItemCard(
                imageUrl: imageUrl,
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

  Widget favouriteItemCard({
    required String imageUrl,
    required String restaurant,
    required String itemName,
    required String price,
    required double rating,
    required String time,
  }) {
    return SizedBox(
      height: 300,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with fixed aspect ratio
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Details area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      itemName,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),

                    // Price & rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 16,
                            ),
                            Text(
                              ' $rating',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 4),
                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        Text(
                          ' $time',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
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
}
