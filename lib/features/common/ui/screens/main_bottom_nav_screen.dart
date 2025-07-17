import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/common/controllers/main_bottom_nav_controller.dart';

class MainBottomNavScreen extends StatelessWidget {
  const MainBottomNavScreen({super.key});
  static const name = '/nav-screen';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainBottomNavController>(
      init: MainBottomNavController(), // Initialize controller once
      builder: (controller) => Scaffold(
        body: controller.screens[controller.selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.white,
                indicatorColor: Colors.white,
                indicatorShape: const StadiumBorder(),
                iconTheme: MaterialStateProperty.resolveWith(
                      (states) => IconThemeData(
                    color: states.contains(MaterialState.selected)
                        ? Colors.green
                        : Colors.grey,
                    size: states.contains(MaterialState.selected) ? 28 : 26,
                  ),
                ),
              ),
              child: NavigationBar(
                height: 60,
                elevation: 5,
                selectedIndex: controller.selectedIndex,
                onDestinationSelected: controller.changePage,
                destinations: [
                  _navItem(controller.selectedIndex == 0, Icons.home_outlined, Icons.home),
                  _navItem(controller.selectedIndex == 1, Icons.article_outlined, Icons.article),
                  const NavigationDestination(
                    icon: Center(child: Icon(Icons.add, color: Colors.green, size: 60)),
                    label: '',
                  ),
                  _navItem(controller.selectedIndex == 3, Icons.favorite_border, Icons.favorite),
                  _navItem(controller.selectedIndex == 4, Icons.person_outline, Icons.person),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  NavigationDestination _navItem(bool isSelected, IconData icon, IconData selectedIcon) {
    return NavigationDestination(
      icon: _navIcon(isSelected, icon),
      selectedIcon: _navIcon(true, selectedIcon),
      label: '',
    );
  }

  Widget _navIcon(bool active, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: active ? Colors.green.withOpacity(0.1) : Colors.transparent,
      ),
      child: Icon(icon, size: 35),
    );
  }
}
