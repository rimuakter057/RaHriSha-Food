import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rahrisha_food/features/common/widgets/dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialBio;
  final String? initialProfileImageUrl;

  const EditProfileScreen({
    Key? key,
    this.initialName = '',
    this.initialEmail = '',
    this.initialPhone = '',
    this.initialBio = '',
    this.initialProfileImageUrl,
  }) : super(key: key);

  static const name = '/edit_profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameTEController;
  late TextEditingController _emailTEController;
  late TextEditingController _numberTEController;
  late TextEditingController _bioTEController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  File? _pickedImage;
  String? _currentProfileImageUrl;

  @override
  void initState() {
    super.initState();
    _nameTEController = TextEditingController(text: widget.initialName);
    _emailTEController = TextEditingController(text: widget.initialEmail);
    _numberTEController = TextEditingController(text: widget.initialPhone);
    _bioTEController = TextEditingController(text: widget.initialBio);
    _currentProfileImageUrl = widget.initialProfileImageUrl;
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _emailTEController.dispose();
    _numberTEController.dispose();
    _bioTEController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<String?> _uploadProfileImage() async {
    if (_pickedImage == null) return _currentProfileImageUrl;

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'User not authenticated.';

      final String fileName = '${user.id}/${DateTime.now().millisecondsSinceEpoch}_profile.jpg';
      final String bucketName = 'profile-photos';

      await Supabase.instance.client.storage.from(bucketName).upload(
        fileName,
        _pickedImage!,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      final publicUrl = Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(fileName);

      return publicUrl;
    } on StorageException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: ${e.message}')),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> updatedData) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;

    try {
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: updatedData),
      );

      return response.user != null;
    } on AuthException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String? imageUrl = await _uploadProfileImage();
    if (_pickedImage != null && imageUrl == null) {
      setState(() => _isLoading = false);
      return;
    }
    imageUrl ??= _currentProfileImageUrl;

    final Map<String, dynamic> updatedMetadata = {
      'name': _nameTEController.text.trim(),
      'phone': _numberTEController.text.trim(),
      'bio': _bioTEController.text.trim(),
    };
    if (imageUrl != null && imageUrl.isNotEmpty) {
      updatedMetadata['profile_image_url'] = imageUrl;
    }

    bool success = await updateUserProfile(updatedMetadata);

    setState(() => _isLoading = false);

    if (success) {

      Navigator.pop(context, {
        'name': _nameTEController.text.trim(),
        'email': widget.initialEmail,
        'phone': _numberTEController.text.trim(),
        'bio': _bioTEController.text.trim(),
        'profile_image_url': imageUrl,
      });
      showSuccessDialog(title: 'Profile Updated', message: ' you successfully update your Profile',onConfirm: (){
        Get.back();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(AppText.editProfile),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!) as ImageProvider
                      : (_currentProfileImageUrl != null && _currentProfileImageUrl!.isNotEmpty
                      ? NetworkImage(_currentProfileImageUrl!)
                      : const AssetImage('assets/default_profile.png') as ImageProvider),
                  radius: 70.r,
                ),
                Positioned(
                  bottom: 2.sp,
                  right: 2.sp,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
              ),
              child: _buildProfileForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _nameTEController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Name',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please Enter Your Name';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Text(AppText.email, style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'example@gmail.com',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(AppText.phoneNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _numberTEController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please Enter Your Phone Number';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Text(AppText.bio, style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _bioTEController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'I love fast food',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
