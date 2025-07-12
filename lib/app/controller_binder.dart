import 'package:get/get.dart';
import 'package:rahrisha_food/features/auth/controllers/forget_password_controller.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_in_controller.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_up_controller.dart';
import 'package:rahrisha_food/features/auth/controllers/user_service.dart';
import 'package:rahrisha_food/features/common/controllers/main_bottom_nav_controller.dart';
import 'package:rahrisha_food/features/home/controllers/home_slider_controller.dart';
import 'package:rahrisha_food/features/recepie/controller/recipe_detils_controller.dart';
import 'package:rahrisha_food/features/recepie/controller/upload_recipe_controller.dart';
import 'package:rahrisha_food/features/wishlist/controller/favourite_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUpController());
    Get.put(UserService());
    Get.put(RecipeDetailController());
    Get.put(FavouritesController());
    Get.put(MainBottomNavController());
    Get.put(SignInController());
    Get.put(HomeCarouselRecipeController());
    Get.put(UploadRecipeController());


    // Only one of these! Choose either eager or lazy:
    //Get.put(ForgotPasswordController());
  }
}