import 'package:flutter/material.dart';
import 'package:rahrisha_food/app/app_logo.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';
import 'package:rahrisha_food/features/home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String name='splash';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   _moveToNextScreen();
  // }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                AppText.foodSwift,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
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
