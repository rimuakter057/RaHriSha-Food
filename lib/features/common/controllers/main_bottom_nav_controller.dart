// lib/app/controllers/main_bottom_nav_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/blog/screen/blog_screen.dart';
import 'package:rahrisha_food/features/home/screens/home_screen.dart';
import 'package:rahrisha_food/features/recepie/screens/upload_recipe.dart';
import 'package:rahrisha_food/features/user_profile/ui/screen/user_profile.dart';
import 'package:rahrisha_food/features/wishlist/screen/wishlist_screen.dart';

class MainBottomNavController extends GetxController {
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  final List<Widget> screens = [
    const HomeScreen(),
    const BlogScreen(),
    const UploadRecipe(),
    FavouritesScreen(),
    const UserProfile(),
  ];

  void changePage(int index) {
    _selectedIndex.value = index;
    print('DEBUG: Changed selected index to: $index');
  }

  @override
  void onInit() {
    super.onInit();
    print('DEBUG: Controller initialized.');
  }

  @override
  void onClose() {
    print('DEBUG: Controller closed.');
    super.onClose();
  }
}
