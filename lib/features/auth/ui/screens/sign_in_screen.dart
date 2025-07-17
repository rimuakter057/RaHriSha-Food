import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/core/widgets/show_success_toast.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_in_controller.dart';
import 'package:rahrisha_food/features/auth/ui/screens/forgot_password.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_up_screen.dart';
import 'package:rahrisha_food/features/common/ui/screens/main_bottom_nav_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.5, 1, curve: Curves.easeOut),
        ));

        _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C2D),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1C3A),
                  Color(0xFF0A0C2D),
                ],
              ),
            ),
          ),

          // Animated food image banner with parallax effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 280.h,
              child: Image.asset(
                'assets/images/6024359.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 240.h),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
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
                      child: _buildSignInForm(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              "Sign in to continue",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Email Field
          Text(
            AppText.email,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
    hintText: "Enter your email address",
    ),
            validator: (value) {
              if (!EmailValidator.validate(value ?? '')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),

          // Password Field
          Text(
            AppText.password,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _passwordTEController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
                hintText:AppText.password,
                //icon:Icon(Icons.lock_outline)
            ).copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),

          // Remember Me & Forgot Password
          Row(
            children: [
              Transform.scale(
                scale: 0.9,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.grey[400],
                  ),
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                ),
              ),
              Text(
                'Remember Me',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Get.toNamed(ForgotPasswordScreen.name),
                child: Text(
                  AppText.forgotPassword,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 3,
                shadowColor: AppColors.primaryColor.withOpacity(0.3),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final email = _emailTEController.text.trim();
                  final password = _passwordTEController.text.trim();
                  Get.find<SignInController>().login(email, password);
                }
              },
              child: Text(
                AppText.login,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'Or continue with',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Social Login Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _socialButton(FontAwesomeIcons.facebookF, const Color(0xFF3b5998)),
              _socialButton(FontAwesomeIcons.google, const Color(0xFFdb4437)),
              _socialButton(FontAwesomeIcons.apple, Colors.black),
            ],
          ),
          SizedBox(height: 32.h),

          // Sign Up Link
          Center(
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.sp,
                ),
                children: [
                  TextSpan(
                    recognizer:TapGestureRecognizer()..onTap=(){
                      Get.to(SignUpScreen());
                    } ,
                    text: AppText.signup,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
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
  

  Widget _socialButton(IconData icon, Color bgColor) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: bgColor,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}