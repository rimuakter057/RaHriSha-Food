import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0C2D),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80.h),
            Text(
              'Reset Password',
              style: TextStyle(fontSize: 28.sp,fontWeight: FontWeight.w500,color: Colors.white),

            ),
            SizedBox(height: 50.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 50.sp),
              height: 695.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24)),
              ),
              child: _buildSignUpForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.password, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _passwordTEController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
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
          Text(AppText.confirmPassword, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordTEController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: AppText.confirmPassword,
              suffixIcon: Icon(Icons.remove_red_eye),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if ((value?.trim().isEmpty ?? true) || value!.length < 6) {
                return 'Please Enter A Password More Than 6 Letters';
              } else if(value != _passwordTEController.text){
                return 'Passwords do not match ';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){

                }
              },
              child: Text('Reset Password', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
