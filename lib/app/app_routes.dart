import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/auth/ui/screens/forgot_password.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_up_screen.dart';
import 'package:rahrisha_food/features/auth/ui/screens/splash_screen.dart';
import 'package:rahrisha_food/features/auth/ui/screens/verify_otp_screen.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';
import 'package:rahrisha_food/features/edit_profile/ui/screen/edit_profile_screen.dart';
import 'package:rahrisha_food/features/recepie/screens/Edit_recipe.dart';
import 'package:rahrisha_food/features/recepie/screens/recipe_details.dart';
import 'package:rahrisha_food/features/recepie/screens/upload_recipe.dart';
import 'package:rahrisha_food/features/serch/screens/search_screen.dart';
import 'package:rahrisha_food/features/user_profile/ui/screen/user_profile.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print("route requested: ${settings.name}");

    if (settings.name == SplashScreen.name) {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    } else if (settings.name == SignInScreen.name) {
      return MaterialPageRoute(builder: (_) => const SignInScreen());
    } else if (settings.name == SignUpScreen.name) {
      return MaterialPageRoute(builder: (_) => const SignUpScreen());
    } else if (settings.name == VerifyOtpScreen.name) {
      final args = settings.arguments;
      if (args is Map<String, String>) {
        final email = args['email'] ?? '';
        final otp = args['otp'] ?? '';
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(email: email, otp: otp),
        );
      }
      return MaterialPageRoute(
        builder: (_) => VerifyOtpScreen(email: '', otp: ''),
      );
    } else if (settings.name == ForgotPasswordScreen.name) {
      return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
    } else if (settings.name == MainBottomNavScreen.name) {
      return MaterialPageRoute(builder: (_) => const MainBottomNavScreen());
    } else if (settings.name == UploadRecipe.name) {
      return MaterialPageRoute(builder: (_) => UploadRecipe());
    } else if (settings.name == RecipeEditPage.name) {
      return MaterialPageRoute(builder: (_) => RecipeEditPage());
    } else if (settings.name == RecipeDetailPage.name) {
      return MaterialPageRoute(builder: (_) => RecipeDetailPage());
    } else if (settings.name == UserProfile.name) {
      return MaterialPageRoute(builder: (_) => UserProfile());
    } else if (settings.name == SearchScreen.name) {
      return MaterialPageRoute(builder: (_) => const SearchScreen());
    } else if (settings.name == EditProfileScreen.name) {
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());
    } else {
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('404 - Page not found')),
        ),
      );
    }
  }
}
