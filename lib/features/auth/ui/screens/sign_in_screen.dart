import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/core/widgets/delete_popup.dart';
import 'package:rahrisha_food/core/widgets/show_success_toast.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_in_controller.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_up_screen.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';
import 'package:rahrisha_food/features/home/screens/home_screen.dart';

import 'forgot_password.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
static const String name='sign_in';
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedRole = 'user';
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(0xFF0A0C2D),
      body: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(height: 80.h),
              Text(
                AppText.login,
                style: textTheme.titleLarge!.copyWith(color: AppColors.white,fontSize: 25.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                'Please sign in to your existing account',
                style: textTheme.titleSmall,
              ),
              SizedBox(height: 50.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 50.sp),
                height: 670.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24)),
                ),
                child: _buildSignInForm(),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.email, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'example@gmail.com',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (String? value) {
              String email = value ?? '';
              if (!EmailValidator.validate(email)) {
                return 'Please Enter Your Email';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Text(AppText.password, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _passwordTEController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: AppText.password,
              suffixIcon: Icon(Icons.remove_red_eye),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (String? value) {
              if ((value?.trim().isEmpty ?? true) || value!.length < 6) {
                return 'Please Enter A Password More Than 6 Letters';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              Text('Remember Me'),
              Spacer(),
              TextButton(
                onPressed: () {
                  Get.toNamed( ForgotPasswordScreen.name);
                },
                child: Text(
                  AppText.forgotPassword,
                  style: TextStyle(color: Colors.pink),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final email = _emailTEController.text.trim();
                  final password = _passwordTEController.text.trim();
                  Get.find<SignInController>().login(email, password);
                  showSuccessToast(context: context, icon: Icons.done, title: 'Sign in success',);
                  //Get.to(MainBottomNavScreen());
                }
              },

              child: Text(AppText.login, style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("don't have an account?"),
              GestureDetector(
                onTap: () {
                  Get.toNamed( SignUpScreen.name);
                },
                child: Text(
                  AppText.signup,
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Center(child: Text('Or', style: TextStyle(color: Colors.grey))),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF3b5998),
                child: Icon(
                  FontAwesomeIcons.facebook,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              CircleAvatar(
                backgroundColor: Color(0xFF3b5998),
                child: Icon(
                  FontAwesomeIcons.twitter,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              CircleAvatar(
                backgroundColor: Color(0xFF3b5998),
                child: Icon(
                  FontAwesomeIcons.linkedin,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}






