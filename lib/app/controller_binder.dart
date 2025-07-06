import 'package:get/get.dart';
import 'package:rahrisha_food/features/auth/controllers/forget_password_controller.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_in_controller.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_up_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUpController());
    Get.put(SignInController());
    // Only one of these! Choose either eager or lazy:
    //Get.put(ForgotPasswordController());
  }
}