import 'package:flutter/material.dart';
import 'package:rahrisha_food/app/assets_path.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AssetsPath.appLogo, width: 200);
  }
}
