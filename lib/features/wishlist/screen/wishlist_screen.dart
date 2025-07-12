import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/wishlist/controller/favourite_controller.dart';

abstract class FavouritesUI {
  Widget favouriteItemCard({
    required String imageUrl,

    required String itemName,
    required double rating,
    required String time,
    required VoidCallback onDelete,
    required VoidCallback onTap,

  });
}

mixin FavouritesUIMixin implements FavouritesUI {
  @override
  Widget favouriteItemCard({
    required String imageUrl,
    required String itemName,
    required double rating,
    required String time,
    required VoidCallback onDelete,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[700], size: 16),
                          Text(' $rating', style: const TextStyle(fontSize: 12)),
                          const Spacer(),
                          Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                          Text(' $time', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: IconButton(
                  icon: const Icon(Icons.delete, size: 26, color: Colors.red),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavouritesScreen extends StatelessWidget with FavouritesUIMixin {
  FavouritesScreen({super.key});

  static const name = 'favourite-list';

  final FavouritesController favouritesController = Get.find<FavouritesController>();

  Future<void> _onRefresh() async {
    // Re-load from storage
    favouritesController.onInit(); // or call _loadFavourites if you want more control
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Obx(() {
              if (favouritesController.favouriteItems.isEmpty) {
                return const Center(
                  child: Text(
                    'No favourite items yet. Add some from the Home screen!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return GridView.builder(
                itemCount: favouritesController.favouriteItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (_, i) {
                  final item = favouritesController.favouriteItems[i];
                  return favouriteItemCard(
                    imageUrl: item['cover_photo_url'] ?? 'https://via.placeholder.com/150',
                    itemName: item['name'] ?? 'No Name',
                    rating: (item['average_rating'] as num?)?.toDouble() ?? 0.0,
                    time: item['time'] ?? 'N/A',
                    onDelete: () => favouritesController.removeFavourite(item), onTap: () {
    final int? recipeId = item['id'] as int?;
    if (recipeId != null) {
    debugPrint("Tapped wishlist item. Navigating to RecipeDetailPage with ID: $recipeId");
    Get.toNamed('/recipe-details', arguments: recipeId);
                  }
    });
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
