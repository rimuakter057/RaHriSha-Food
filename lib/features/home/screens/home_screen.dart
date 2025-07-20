import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/assets_path.dart';
import 'package:rahrisha_food/features/auth/controllers/user_service.dart';
import 'package:rahrisha_food/features/contact/contact_screen.dart';
import 'package:rahrisha_food/features/home/controllers/fetch_recipe_controller.dart';
import 'package:rahrisha_food/features/home/widgets/home_carousel_slider.dart';
import 'package:rahrisha_food/features/recepie/controller/recipe_detils_controller.dart';
import 'package:rahrisha_food/features/recepie/screens/recipe_details.dart';
import 'package:rahrisha_food/features/user_profile/ui/screen/user_profile.dart';
import 'package:rahrisha_food/features/wishlist/controller/favourite_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String name = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final HomeController homeController = Get.put(HomeController());
  final UserService userService = Get.find<UserService>();
  final FavouritesController favouritesController = Get.find<FavouritesController>();
  final RecipeDetailController recipeDetailController = Get.find<RecipeDetailController>();

  late final TabController _tabController = TabController(length: 1, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await homeController.fetchRecipes(searchQuery: homeController.searchController.text);
  }

  late bool isSearch;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: GetBuilder<HomeController>(
          id: 'homeAppBar',
          builder: (controller) {
            return Obx(() {
              if (controller.isSearching.value) {
                return TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.black38),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black38),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.onSearchTextChanged('');
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.amber),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                  style: const TextStyle(color: Colors.black38),
                  onChanged: controller.onSearchTextChanged,
                  autofocus: true,
                );
              } else {
                return GestureDetector(
                  onTap: (){Get.to(UserProfile());},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        userService.userName.value.isNotEmpty
                            ? userService.userName.value
                            : 'Guest',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
            });
          },
        ),

        leading: Obx(() {
          final imageUrl = userService.userProfileImageUrl.value;
          return Container(
            margin: EdgeInsets.only(left: 5),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.amber)
            ),
            child: CircleAvatar(
              radius: 40.r,
              backgroundColor: Colors.white,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
            ),
          );
        }),
        actions: [
          IconButton(
            icon: Badge(
              child: const Icon(Icons.notifications, color: Colors.white),
            ),
            onPressed: () {},
          ),
          GetBuilder<HomeController>(
            id: 'homeAppBar',
            builder: (controller) {
              return IconButton(
                icon: Icon(
                  controller.isSearching.value ? Icons.close : Icons.search,
                  color: Colors.white,
                ),
                onPressed: controller.toggleSearch,
              );
            },
          ),
        ],
      ),
      floatingActionButton: const ContactFab(),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // Carousel with shadow
              HomeCarouselSlider(),
              SizedBox(height: 24.h),
              // Featured Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Recipes',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              // Featured Recipes Horizontal List
              SizedBox(
                height: 200.h,
                child: GetBuilder<HomeController>(
                  id: 'featuredRecipes',
                  builder: (controller) {
                    if (controller.isLoadingFeatured.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.hasErrorFeatured.value) {
                      return Center(child: Text(controller.errorMessageFeatured.value));
                    }
                    if (controller.displayedFeaturedRecipes.isEmpty) {
                      return const Center(child: Text('No featured recipes found.'));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 16.w),
                      itemCount: controller.displayedFeaturedRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = controller.displayedFeaturedRecipes[index];
                        final isFav = favouritesController.isFavourite(recipe);
                        return Container(
                          width: 160.w,
                          margin: EdgeInsets.only(right: 16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              final int? recipeId = recipe['id'] as int?;
                              if (recipeId != null) {
                                Get.toNamed(RecipeDetailPage.name, arguments: recipeId);
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Stack(
                                children: [
                                  // Recipe Image
                                  Image.network(
                                    recipe['cover_photo_url'] ?? '',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Image.asset(
                                          AssetsPath.homeTopImage,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                  ),
                                  // Gradient Overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Favorite Button
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () =>
                                          favouritesController.toggleFavourite(recipe),
                                      child: Container(
                                        padding: EdgeInsets.all(6.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isFav ? Icons.favorite : Icons.favorite_border,
                                          color: isFav ? Colors.red : AppColors.primary,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Recipe Info
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe['name'] ?? 'No Name',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.people_outline,
                                                color: Colors.white70,
                                                size: 14.sp,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                '${recipe['servings'] ?? 'N/A'} Servings',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 10.sp,
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
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              // All Recipes Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'All Recipes',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildTabContent(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return GetBuilder<HomeController>(
      id: 'allRecipes',
      builder: (controller) {
        if (controller.isLoadingAllRecipes.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hasErrorAllRecipes.value) {
          return Center(child: Text(controller.errorMessageAllRecipes.value));
        }
        if (controller.displayedAllRecipes.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                controller.searchController.text.isNotEmpty &&
                    !controller.isLoadingAllRecipes.value
                    ? 'No matching recipes found.'
                    : 'No recipes available.',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.displayedAllRecipes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final recipe = controller.displayedAllRecipes[index];
            final isFav = favouritesController.isFavourite(recipe);
            return GestureDetector(
              onTap: () {
                final int? recipeId = recipe['id'] as int?;
                if (recipeId != null) {
                  Get.toNamed(RecipeDetailPage.name, arguments: recipeId);
                }
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadowColor: Colors.grey.withOpacity(0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Image
                    ClipRRect(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.r)),
                      child: Stack(
                        children: [
                          Image.network(
                            recipe['cover_photo_url'] ?? '',
                            height: 120.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  AssetsPath.homeTopImage,
                                  fit: BoxFit.cover,
                                  height: 120.h,
                                  width: double.infinity,
                                ),
                          ),
                          // Favorite Button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () =>
                                  favouritesController.toggleFavourite(recipe),
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.red : AppColors.primary,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Recipe Details
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe['name'] ?? '',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          RatingBarIndicator(
                            rating:
                            (recipe['average_rating'] as num?)?.toDouble() ?? 0.0,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 14.sp,
                            direction: Axis.horizontal,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.reviews_outlined,
                                size: 14.sp,
                                color: AppColors.secondaryText,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${recipe['review_count'] ?? 0} Reviews',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}