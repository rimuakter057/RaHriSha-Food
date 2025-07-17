import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/features/blog/controller/add_blog_controller.dart';

class AddBlogScreen extends StatelessWidget {
  const AddBlogScreen({super.key});

  static const String name = '/add_blog';

  @override
  Widget build(BuildContext context) {
    final AddBlogController addBlogController = Get.put(AddBlogController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Blog Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<AddBlogController>(
        builder: (controller) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// ✅ Image Picker
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: controller.imageFile != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    controller.imageFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 50, color: Colors.grey[600]),
                      const SizedBox(height: 10),
                      Text(
                        'Tap to select a cover image',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              /// ✅ Title Input
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'Blog Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.title),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 16.0),

              /// ✅ Content Input
              TextField(
                controller: controller.contentController,
                decoration: InputDecoration(
                  labelText: 'Blog Content',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.article),
                ),
                maxLines: 10,
                minLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 32.0),

              /// ✅ Publish Button
              ElevatedButton(
                onPressed: controller.isLoading
                    ? null
                    : () => controller.addBlogPost(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: controller.isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
                    : Text(
                  'Publish Blog Post',
                  style: TextStyle(fontSize: 18, color: AppColors.white),
                ),
              ),
              const SizedBox(height: 16.0),

              /// ✅ Error Message
              if (controller.errorMessage.isNotEmpty)
                Text(
                  controller.errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
