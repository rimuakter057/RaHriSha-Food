import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String otp;

  const VerifyOtpScreen({Key? key, required this.email, required this.otp}) : super(key: key);

  static const String name = 'verify_otp';

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C2D),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80.h),
            Text(
              'Verification Code',
              style: textTheme.titleLarge!.copyWith(color: Colors.white, fontSize: 25.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              'We have sent a code to ${widget.email}',
              style: textTheme.titleSmall!.copyWith(color: Colors.white),
            ),
            SizedBox(height: 30.h),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              height: 677.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24)),
              ),
              child: _buildOtpForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter OTP', style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          PinCodeTextField(
            length: 5,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 70.h,
              fieldWidth: 60.w,
              activeFillColor: Colors.white,
              selectedFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              errorBorderColor: Colors.red,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.white,
            enableActiveFill: true,
            controller: _otpController,
            appContext: context,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your OTP';
              }
              if (value.trim().length != 5) {
                return 'OTP must be 5 digits';
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
                if (_formKey.currentState!.validate()) {
                  if (_otpController.text.trim() == widget.otp) {
                    // OTP verified
                    Get.snackbar('Success', 'OTP Verified! Please login.');
                    Get.offAllNamed(SignInScreen.name); // Navigate to login screen, remove all previous routes
                  } else {
                    Get.snackbar('Error', 'Invalid OTP. Please try again.');
                  }
                }
              },
              child: const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
