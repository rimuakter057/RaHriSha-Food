
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';
import 'package:rahrisha_food/features/recepie/screens/Edit_recipe.dart';
import 'package:rahrisha_food/features/recepie/screens/recipe_details.dart';
import 'package:rahrisha_food/features/recepie/screens/upload_recipe.dart';
import 'package:rahrisha_food/features/user_profile/ui/screen/user_profile.dart';

import '../features/auth/ui/screens/forgot_password.dart';
import '../features/auth/ui/screens/sign_in_screen.dart';
import '../features/auth/ui/screens/sign_up_screen.dart';
import '../features/auth/ui/screens/splash_screen.dart';
import '../features/auth/ui/screens/verify_otp_screen.dart';
import '../features/edit_profile/ui/screen/edit_profile_screen.dart';
import '../features/serch/screens/search_screen.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print("route requested: ${settings.name}");
    late Widget route;
    if (settings.name == SplashScreen.name) {
      route = const SplashScreen();
    } else if (settings.name == SignInScreen.name) {
      route = const SignInScreen();
    } else if (settings.name == SignUpScreen.name) {
      route = const SignUpScreen();
    } else if (settings.name == VerifyOtpScreen.name) {
      route = VerifyOtpScreen();
    }else if (settings.name == ForgotPasswordScreen.name) {
      route = ForgotPasswordScreen();
    }
    else if (settings.name == MainBottomNavScreen.name) {
      route = const MainBottomNavScreen();
    } else if (settings.name == UploadRecipe.name) {
      route = UploadRecipe();
    } else if (settings.name == RecipeEditPage.name) {
      route = RecipeEditPage();
    } else if (settings.name == RecipeDetailPage.name) {
      route = RecipeDetailPage();
    } else if (settings.name == UserProfile.name) {
      route = UserProfile();
    } else if (settings.name == SearchScreen.name) {
      route = const SearchScreen();
    } else if (settings.name == EditProfileScreen.name) {
      route = const EditProfileScreen();
    }

    return MaterialPageRoute(
      builder: (context) {
        return route;
      },
    );
  }
}