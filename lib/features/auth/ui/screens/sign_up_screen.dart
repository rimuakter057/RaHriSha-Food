import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/core/widgets/show_success_toast.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_up_controller.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';
import 'package:rahrisha_food/features/common/widgets/dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String name = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _signUpController = Get.put(SignUpController());

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [Color(0xFF1A1C3A), Color(0xFF0A0C2D)],
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              // ),
            ),
          ),

          // Top Hero Image with gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 300.h,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/6024359.jpg', // Replace with your image path
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 160.h),

                  // Title Section with animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          Text(
                            'Join Us Today',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Create your account to get started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Form Card with animation
                  Expanded(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32.r),
                              topRight: Radius.circular(32.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                                offset: const Offset(0, -10),
                              ),
                            ],
                          ),
                          child: _buildForm(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: _nameCtrl,
              icon: Icons.person_outline,
              validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              controller: _emailCtrl,
              icon: Icons.email_outlined,
              keyboard: TextInputType.emailAddress,
              validator: (v) => EmailValidator.validate(v ?? '') ? null : 'Enter a valid email',
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              label: 'Password',
              hint: 'Create a password',
              controller: _passCtrl,
              icon: Icons.lock_outline,
              obscure: _obscurePassword,
              toggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
              validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              controller: _confirmPassCtrl,
              icon: Icons.lock_outline,
              obscure: _obscureConfirm,
              toggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
              validator: (v) => v == null || v.length < 6 ? 'Password must be at least 6 characters' : null,
            ),
            SizedBox(height: 32.h),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 3,
                  shadowColor: AppColors.primaryColor.withOpacity(0.3),
                ),
                onPressed: _submit,
                child: Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Login Link
            Text.rich(
              TextSpan(
                text: "Already have an account? ",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                children: [
                  TextSpan(
                    text: 'Sign In',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.toNamed(SignInScreen.name),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    VoidCallback? toggleObscure,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          style: TextStyle(fontSize: 14.sp),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            prefixIcon: Icon(
              icon,
              size: 20.sp,
              color: Colors.grey[600],
            ),
            suffixIcon: toggleObscure != null
                ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
                size: 20.sp,
              ),
              onPressed: toggleObscure,
            )
                : null,
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passCtrl.text != _confirmPassCtrl.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        borderRadius: 12,
        margin: EdgeInsets.all(16.w),
      );
      return;
    }

    final success = await _signUpController.signUp(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );

    if (success) {
      showSuccessDialog(title: 'Success', message: ' you successfully sign up',onConfirm: (){
        Get.offAllNamed(SignInScreen.name);
      });

    } else {
      showSuccessDialog(title: 'Error',
          icon: Icons.error_outline,
          iconColor: Colors.red,
          message: ' Sign up failed.',onConfirm: (){
            Get.back();
          });
    }
  }
}