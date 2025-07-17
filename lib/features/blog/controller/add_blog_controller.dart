// lib/features/blog/controller/add_blog_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rahrisha_food/features/auth/controllers/user_service.dart';
import 'package:rahrisha_food/features/common/widgets/dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rahrisha_food/features/blog/controller/blogcontroller.dart';

class AddBlogController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final UserService userService = Get.find<UserService>();

  File? imageFile;
  bool isLoading = false;
  String errorMessage = '';
  final userId = Supabase.instance.client.auth.currentUser?.id;

  @override
  void onInit() {
    super.onInit();
    // Optional: Pre-fill authorController from user service if needed
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      errorMessage = '';
    } else {
      Get.snackbar(
        'Image Selection',
        'No image selected.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
    update();
  }

  Future<String?> _uploadImage() async {
    if (imageFile == null) {
      errorMessage = 'Please select a cover image for your blog.';
      update();
      return null;
    }

    try {
      isLoading = true;
      update();

      final String fileName =
          'blog_images/${DateTime.now().millisecondsSinceEpoch}.png';

      await _supabaseClient.storage
          .from('blogcovers')
          .upload(
            fileName,
            imageFile!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = _supabaseClient.storage
          .from('blogcovers')
          .getPublicUrl(fileName);

      return publicUrl;
    } on StorageException catch (e) {
      errorMessage = 'Image upload failed: ${e.message}';
      update();
      return null;
    } catch (e) {
      errorMessage = 'An unexpected error occurred during image upload.';
      update();
      return null;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> addBlogPost() async {
    errorMessage = '';
    isLoading = true;
    update();

    if (titleController.text.trim().isEmpty) {
      errorMessage = 'Blog title cannot be empty.';
      isLoading = false;
      update();
      return;
    }

    if (contentController.text.trim().isEmpty) {
      errorMessage = 'Blog content cannot be empty.';
      isLoading = false;
      update();
      return;
    }

    if (imageFile == null) {
      errorMessage = 'Please select a cover image for your blog.';
      isLoading = false;
      update();
      return;
    }

    final imageUrl = await _uploadImage();
    if (imageUrl == null) {
      isLoading = false;
      update();
      return;
    }

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        errorMessage = 'User is not authenticated.';
        isLoading = false;
        update();
        return;
      }

      String authorName = userService.userName.value;
      if (authorName.isEmpty || authorName == 'No Name') {
        authorName = user.email ?? 'Anonymous';
      }

      await _supabaseClient.from('blogpost').insert({
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
        'author': authorName,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'time_ago': 'Just now',
        'user_id': user.id,
      });

      titleController.clear();
      contentController.clear();
      imageFile = null;

      if (Get.isRegistered<BlogController>()) {
        Get.find<BlogController>().fetchBlogs();
      }

      showSuccessDialog(
        title: 'Blog Post Added!',
        message: ' Your blog post has been successfully published.',
        onConfirm: () {
          Get.back();
          update();
        },

      );
      update();
    } catch (e) {
      errorMessage = 'An unexpected error occurred.';
    } finally {
      isLoading = false;
      update();
    }
  }
}
