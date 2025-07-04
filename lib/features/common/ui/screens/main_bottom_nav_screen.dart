
import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/home/screens/home_screen.dart';


class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});
  static const routeName = '/nav-screen';

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  final int _selectedIndex = 0;

  final List <Widget>_screens=[
    const HomeScreen(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_screens[_selectedIndex],
        bottomNavigationBar:NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              label: 'Wishlist',
            ),
          ],
        )
    );
  }
}





