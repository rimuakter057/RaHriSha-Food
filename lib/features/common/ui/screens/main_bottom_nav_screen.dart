import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/home/screens/home_screen.dart';
import 'package:rahrisha_food/features/user_profile/ui/screen/user_profile.dart';
import '../../../recepie/screens/Edit_recipe.dart';
import '../../../recepie/screens/recipe_details.dart';
import '../../../recepie/screens/upload_recipe.dart';
import '../../../serch/screens/search_screen.dart';
import '../../../wishlist/screen/wishlist_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});
  static const name = '/nav-screen';

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    Scaffold(),
    FavouritesScreen(),
    UserProfile(),
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
        destinations:  [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.newspaper), label: 'Blog'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'favourite'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),


        ],
      ),
    );
  }
}
