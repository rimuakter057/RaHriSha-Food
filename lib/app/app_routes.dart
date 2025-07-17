import 'package:flutter/material.dart';
import 'package:rahrisha_food/features/auth/ui/screens/forgot_password.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_up_screen.dart';
import 'package:rahrisha_food/features/auth/ui/screens/splash_screen.dart';
import 'package:rahrisha_food/features/auth/ui/screens/verify_otp_screen.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';
import 'package:rahrisha_food/features/edit_profile/ui/screen/edit_profile_screen.dart';
import 'package:rahrisha_food/features/recepie/screens/Edit_recipe.dart'; // Assuming this is distinct if you keep it
import 'package:rahrisha_food/features/recepie/screens/my_recipe_details.dart';
import 'package:rahrisha_food/features/recepie/screens/recipe_details.dart';
import 'package:rahrisha_food/features/recepie/screens/upload_recipe.dart';
import 'package:rahrisha_food/features/user_profile/ui/screen/user_profile.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print("Route requested: ${settings.name}");
    print("Arguments received: ${settings.arguments}");

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
        print("VerifyOtpScreen args: email=$email, otp=$otp");
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(email: email, otp: otp),
        );
      }
      print("VerifyOtpScreen called with missing or invalid args. Providing empty.");
      // Fallback for missing/invalid args
      return MaterialPageRoute(
        builder: (_) => const VerifyOtpScreen(email: '', otp: ''),
      );
    } else if (settings.name == ForgotPasswordScreen.name) {
      return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()); // Added const
    } else if (settings.name == MainBottomNavScreen.name) {
      return MaterialPageRoute(builder: (_) => const MainBottomNavScreen());
    } else if (settings.name == UploadRecipe.name) {
      // UploadRecipe might be used for editing, so it might expect arguments.
      // If it takes a 'recipe' argument for editing, you'd handle it here.
      // For now, assuming it takes no required arguments on direct navigation.
      return MaterialPageRoute(builder: (_) => const UploadRecipe()); // Added const
    } else if (settings.name == RecipeEditPage.name) {
      // If RecipeEditPage takes specific arguments, handle them here.
      return MaterialPageRoute(builder: (_) => const RecipeEditPage()); // Added const
    } else if (settings.name == RecipeDetailPage.name) {
      final args = settings.arguments;
      print("Navigating to RecipeDetailPage with args: $args");
      if (args is int) {
        return MaterialPageRoute(
          builder: (_) => RecipeDetailPage(recipeId: args),
        );
      } else {
        print("RecipeDetailPage called with invalid or missing recipeId! Arguments: $args");
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Error: Invalid or missing Recipe ID.'),
            ),
          ),
        );
      }
    } else if (settings.name == MyRecipeDetails.name) {
      // This was incorrectly nested. Now it's a top-level check.
      final args = settings.arguments;
      print("Navigating to MyRecipeDetails with args: $args");
      if (args is int) {
        return MaterialPageRoute(
          builder: (_) => MyRecipeDetails(recipeId: args),
        );
      } else {
        print("MyRecipeDetails called with invalid or missing recipeId! Arguments: $args");
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Error: Invalid or missing My Recipe ID.'),
            ),
          ),
        );
      }
    } else if (settings.name == UserProfile.name) {
      return MaterialPageRoute(builder: (_) => const UserProfile()); // Added const
    } else if (settings.name == EditProfileScreen.name) {
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());
    } else {
      // Default case for unknown routes
      print("Route not found: ${settings.name}");
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('404 - Page not found')),
        ),
      );
    }
  }
}