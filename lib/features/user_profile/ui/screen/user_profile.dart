import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/features/auth/ui/screens/sign_in_screen.dart';
import 'package:rahrisha_food/features/edit_profile/ui/screen/edit_profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart'; // <-- Add if using GetX for routing!

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  static const String name = 'profile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _bio = 'I love fast food';
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
        final response = await Supabase.instance.client
            .from('users')
            .select('name, phone, bio, profile_image_url')
            .eq('id', user.id)
            .single()
            .limit(1);

        setState(() {
          _name = response['name'] ?? 'No Name';
          _email = user.email ?? 'No Email';
          _phone = response['phone'] ?? 'No Phone';
          _bio = response['bio'] ?? 'I love fast food';
          _profileImageUrl = response['profile_image_url'];
        });
      } catch (e) {
        debugPrint('Error fetching user data: $e');
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
    await Supabase.instance.client.auth.signOut();
    // Replace with your actual route to your SignIn page
    Get.offAll(SignInScreen()); // or Navigator.pushReplacementNamed(context, '/signIn')
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Personal Info',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updated = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(
                    initialName: _name,
                    initialEmail: _email,
                    initialPhone: _phone,
                    initialBio: _bio,
                    initialProfileImageUrl: _profileImageUrl,
                  ),
                ),
              );

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
            child: Text(
              'Edit',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
        child: Column(
          children: [
            _buildProfileImage(_name),
            SizedBox(height: 30.h),
            _buildContainer(),
            SizedBox(height: 30.h),

            // ✅ Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center _buildProfileImage(String name) {
    return Center(
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                ? NetworkImage(_profileImageUrl!)
                : const AssetImage('assets/images/sharif.jpg') as ImageProvider,
            radius: 60.r,
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                _bio,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xffF6F8FA),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          _infoRow(
            icon: FontAwesomeIcons.user,
            title: 'Full Name',
            value: _name,
            iconColor: AppColors.secondary,
          ),
          SizedBox(height: 20.h),
          _infoRow(
            icon: Icons.email_outlined,
            title: 'Email',
            value: _email,
            iconColor: const Color(0xffA09EFD),
          ),
          SizedBox(height: 20.h),
          _infoRow(
            icon: FontAwesomeIcons.phone,
            title: 'Phone Number',
            value: _phone,
            iconColor: const Color(0xff4FA7FF),
          ),
        ],
      ),
    );
  }

  Row _infoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: iconColor),
        ),
        SizedBox(width: 15.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
