import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_logo.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String name='/splash';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    session!=null?Get.offAll(MainBottomNavScreen()):Get.offAll(SignInScreen());
  }

  final session = Supabase.instance.client.auth.currentSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              const AppLogo(),
              const Spacer(),
              SizedBox(height: 16),
              Text(
                'FoodieFiesta ',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900,color: AppColors.primaryColor),
              ),
              SizedBox(height: 16),
              Text(
                AppText.deliciousFood,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(AppText.version),
            ],
          ),
        ),
      ),
    );
  }
}
