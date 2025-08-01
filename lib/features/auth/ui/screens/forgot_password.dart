import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/features/auth/ui/screens/verify_otp_screen.dart';

import '../../../../app/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const String name='/forget_pass';
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme =Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80.h),
            Text(
              AppText.forgotPassword,
              style: textTheme.titleLarge!.copyWith(color: AppColors.white,fontSize: 25.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please sign in to your existing account',
              style: textTheme.titleSmall,
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 30.sp),
              height: 717.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24)),
              ),
              child: _buildForgotPasswordForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordForm() {
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
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,),
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  Get.toNamed(VerifyOtpScreen.name);
                }
              },
              child: Text('Send Code', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
