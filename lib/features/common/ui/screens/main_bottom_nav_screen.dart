import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/home/screens/home_screen.dart';

import '../../../recepie/screens/Edit_recipe.dart';
import '../../../recepie/screens/recipe_details.dart';
import '../../../recepie/screens/upload_recipe.dart';
import '../../../serch/screens/search_screen.dart';
import '../../../wishlist/screen/wishlist_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});
  static const routeName = '/nav-screen';

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
   const RecipeEditPage(),
   const RecipeDetailPage (),
    const UploadRecipe(),
    const SearchScreen(),
    FavouritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.category), label: 'edit'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'details'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'upload'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'search'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'favourite'),


        ],
      ),
    );
  }
}
