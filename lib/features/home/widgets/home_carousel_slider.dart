import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/features/home/controllers/fetch_recipe_controller.dart';

class HomeCarouselSlider extends StatelessWidget {
  HomeCarouselSlider({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingFeatured.value) {
        return SizedBox(
          height: 180.h,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
      }

      if (controller.hasErrorFeatured.value) {
        return SizedBox(
          height: 180.h,
          child: Center(
            child: Text(
              controller.errorMessageFeatured.value,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }

      if (controller.displayedFeaturedRecipes.isEmpty) {
        return SizedBox(
          height: 180.h,
          child: Center(
            child: Text(
              'No featured recipes found',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }

      return CarouselSlider.builder(
        itemCount: controller.displayedFeaturedRecipes.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          final recipe = controller.displayedFeaturedRecipes[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Recipe Image
                Image.network(
                  recipe['cover_photo_url']?.toString() ??
                      'https://via.placeholder.com/400x300',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                        color: AppColors.primary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 40.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                // Recipe Title
                Positioned(
                  bottom: 20.h,
                  left: 16.w,
                  right: 16.w,
                  child: Text(
                    recipe['name']?.toString() ?? 'Featured Recipe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          height: 180.h,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.2,
          scrollDirection: Axis.horizontal,
        ),
      );
    });
  }
}