import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});
  static const String name='verify';
  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _verifyOtpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              'Verification Code',
              style: textTheme.titleLarge!.copyWith(color: AppColors.white,fontSize: 25.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'We have sent a code to Your Email',
              style: textTheme.titleSmall!.copyWith(color: AppColors.white,),
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              height: 677.h,
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
          PinCodeTextField(
            length: 4,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 70.h,
              fieldWidth: 60.w,
              activeFillColor: AppColors.white,
              selectedFillColor: AppColors.white,
              inactiveFillColor: AppColors.white,
              errorBorderColor: Colors.red,

            ),
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: AppColors.white,
            enableActiveFill: true,
            controller: _verifyOtpTEController,
            appContext: context,
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please Enter Your Otp';
              }
              return null;
            },
          ),

          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  Get.toNamed(MainBottomNavScreen.name);
                }
              },
              child: Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
