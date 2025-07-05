import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/home/screens/home_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});
  static const routeName = '/nav-screen';

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0; // final বাদ দিয়ে stateful করলাম

  final List<Widget> _screens = [
    const HomeScreen(),
    const Scaffold(body: Center(child: Text("Category Screen"))),
    const Scaffold(body: Center(child: Text("Cart Screen"))),
    const Scaffold(body: Center(child: Text("Wishlist Screen"))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // index update হচ্ছে এখানে
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped, // এটি অ্যাড করো
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.category), label: 'Category'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
        ],
      ),
    );
  }
}
