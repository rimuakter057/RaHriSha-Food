import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/blog/screen/blog_screen.dart';
import 'package:rahrisha_food/features/home/screens/home_screen.dart';
import 'package:rahrisha_food/features/recepie/screens/upload_recipe.dart';
import 'package:rahrisha_food/features/user_profile/ui/screen/user_profile.dart';
import 'package:rahrisha_food/features/wishlist/screen/wishlist_screen.dart';

class MainBottomNavController extends GetxController {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const BlogScreen(),
    const UploadRecipe(),
    FavouritesScreen(),
    const UserProfile(),
  ];

  void changePage(int index) {
    selectedIndex = index;
    update(); // triggers GetBuilder to rebuild
  }
}
