import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/core/widgets/show_success_toast.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_up_controller.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String name = '/sign_up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _signUpController = Get.put(SignUpController());

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
              AppText.signup,
              style: textTheme.titleLarge!.copyWith(
                color: AppColors.white,
                fontSize: 25.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please sign up to get started',
              style: textTheme.titleSmall!.copyWith(color: AppColors.white),
            ),
            SizedBox(height: 50.h),
            Container(
              padding: EdgeInsets.all(24.sp),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            label: AppText.name,
            hint: 'Name',
            controller: _nameCtrl,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
          ),
          SizedBox(height: 20.h),
          _buildTextField(
            label: AppText.email,
            hint: 'example@gmail.com',
            controller: _emailCtrl,
            keyboard: TextInputType.emailAddress,
            validator: (v) => EmailValidator.validate(v ?? '') ? null : 'Enter a valid email',
          ),
          SizedBox(height: 20.h),
          _buildTextField(
            label: AppText.password,
            hint: 'Password',
            controller: _passCtrl,
            obscure: true,
            validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
          ),
          SizedBox(height: 20.h),
          _buildTextField(
            label: AppText.confirmPassword,
            hint: AppText.confirmPassword,
            controller: _confirmPassCtrl,
            obscure: true,
            validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(
                AppText.signup,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              GestureDetector(
                onTap: () => Get.toNamed(SignInScreen.name),
                child: const Text(
                  AppText.login,
                  style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: obscure ? const Icon(Icons.remove_red_eye) : null,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    final confirmPass = _confirmPassCtrl.text.trim();

    if (pass != confirmPass) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final success = await _signUpController.signUp(name, email, pass);
    if (success) {
      showSuccessToast(context: context, icon: Icons.done, title: 'Sign up successful!');
      Get.offAllNamed(SignInScreen.name);
    } else {
      Get.snackbar(
        'Error',
        'Sign up failed',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
