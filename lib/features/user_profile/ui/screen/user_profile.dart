import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/features/auth/controllers/sign_in_controller.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';
import 'package:rahrisha_food/features/blog/screen/user_blog_screen.dart';
import 'package:rahrisha_food/features/edit_profile/ui/screen/edit_profile_screen.dart';
import 'package:rahrisha_food/features/recepie/screens/user_recipe_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  static const String name = 'profile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String _name = '', _email = '', _phone = '', _bio = 'I love fast food';
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final res = await Supabase.instance.client
            .from('users')
            .select('name, phone, bio, profile_image_url')
            .eq('id', user.id)
            .single();
        setState(() {
          _name = res['name'] ?? 'No Name';
          _email = user.email ?? 'No Email';
          _phone = res['phone'] ?? 'No Phone';
          _bio = res['bio'] ?? 'I love fast food';
          _profileImageUrl = res['profile_image_url'];
        });
      } catch (e) {
        setState(() {
          _name = user.userMetadata?['name'] ?? 'No Name';
          _email = user.email ?? 'No Email';
          _phone = user.userMetadata?['phone'] ?? 'No Phone';
          _bio = user.userMetadata?['bio'] ?? 'I love fast food';
          _profileImageUrl = user.userMetadata?['profile_image_url'];
        });
      }
    }
  }

  Future<void> _logout() async {
    Get.find<SignInController>().logout();
    Get.offAll(const SignInScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Personal Info', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600)),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.8),
                      AppColors.primaryColor.withOpacity(0.4)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white, size: 22.sp),
                onPressed: () async {
                  final updated = await Get.to(() => EditProfileScreen(
                    initialName: _name,
                    initialEmail: _email,
                    initialPhone: _phone,
                    initialBio: _bio,
                    initialProfileImageUrl: _profileImageUrl,
                  ));
                  if (updated != null) {
                    setState(() {
                      _name = updated['name'] ?? _name;
                      _email = updated['email'] ?? _email;
                      _phone = updated['phone'] ?? _phone;
                      _bio = updated['bio'] ?? _bio;
                      _profileImageUrl = updated['profile_image_url'] ?? _profileImageUrl;
                    });
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                children: [
                  _profileHeader(),
                  SizedBox(height: 32.h),
                  _infoCard(),
                  SizedBox(height: 32.h),
                  _quickActions(),
                  SizedBox(height: 24.h),
                  _logoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() => Row(
    children: [
      CircleAvatar(
        radius: 50.r,
        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
        backgroundImage: _profileImageUrl?.isNotEmpty == true
            ? NetworkImage(_profileImageUrl!)
            : const AssetImage('assets/images/6024359.jpg') as ImageProvider,
      ),
      SizedBox(width: 20.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_name, style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.grey[800])),
            SizedBox(height: 8.h),
            Text(_bio, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[600], fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    ],
  );

  Widget _infoCard() => Container(
    padding: EdgeInsets.all(24.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 20, spreadRadius: 5, offset: const Offset(0, 10))],
    ),
    child: Column(
      children: [
        _infoItem(FontAwesomeIcons.user, 'Full Name', _name, AppColors.secondary),
        Divider(height: 32.h, color: Colors.grey[200]),
        _infoItem(Icons.email_outlined, 'Email', _email, const Color(0xffA09EFD)),
        Divider(height: 32.h, color: Colors.grey[200]),
        _infoItem(FontAwesomeIcons.phone, 'Phone Number', _phone, const Color(0xff4FA7FF)),
      ],
    ),
  );

  Widget _infoItem(IconData icon, String title, String value, Color color) => Row(
    children: [
      CircleAvatar(
        radius: 22.r,
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20.sp),
      ),
      SizedBox(width: 16.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.w500)),
            SizedBox(height: 4.h),
            Text(value, style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.grey[800], fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ],
  );

  Widget _quickActions() => Row(
    children: [
      Expanded(child: _actionBtn(Icons.article, 'My Blogs', () => Get.to(() => const UserBlogsScreen()))),
      SizedBox(width: 16.w),
      Expanded(child: _actionBtn(Icons.restaurant_menu, 'My Recipes', () => Get.to(() => const UserRecipesScreen()))),
    ],
  );

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap) => ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primaryColor,
      side: BorderSide(color: Colors.grey[200]!),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      elevation: 0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20.sp),
        SizedBox(width: 8.w),
        Text(label, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600)),
      ],
    ),
  );

  Widget _logoutButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: _logout,
      icon: Icon(Icons.logout, size: 20.sp),
      label: Text('Logout', style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        elevation: 2,
      ),
    ),
  );
}
