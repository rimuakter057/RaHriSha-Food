// lib/features/blog/view/blog_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/blog/controller/blogcontroller.dart';
import 'package:rahrisha_food/features/blog/view/add_edit_blog_screen.dart'; // We'll create this

class BlogDetailScreen extends StatelessWidget {
  static const String name = '/blog-detail';

  // We'll pass the entire blog map for display
  final Map<String, dynamic> blog;

  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We can directly use the blog controller for delete/edit actions
    final BlogController blogController = Get.find<BlogController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(blog['title'] ?? 'Blog Post'),
        backgroundColor: Colors.green, // Match your BlogScreen AppBar color
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white), // Edit button
            onPressed: () async {
              // Navigate to AddEditBlogScreen with current blog data for editing
              final bool? result = await Get.toNamed(
                AddEditBlogScreen.name,
                arguments: {'blog': blog}, // Pass the entire blog map
              );
              // If the blog was updated, refresh the list and potentially the detail screen itself
              if (result == true) {
                blogController.fetchBlogs(); // Refresh blogs on the main list
                // If you want the detail screen itself to reflect changes immediately
                // without navigating back and forth, you'd need to make it stateful
                // and refetch the single blog. For simplicity, we assume Get.back
                // from the edit screen will trigger the didChangeDependencies in BlogScreen.
                // Or you could update this specific blog's data directly if it's observable.
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red), // Delete button
            onPressed: () {
              Get.defaultDialog(
                title: 'Confirm Deletion',
                middleText: 'Are you sure you want to delete "${blog['title']}"?',
                textConfirm: 'Delete',
                textCancel: 'Cancel',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                cancelTextColor: Colors.black87,
                onConfirm: () {
                  Get.back(); // Close dialog
                  if (blog['id'] != null) {
                    blogController.deleteBlog(blog['id'] as int);
                  } else {
                    Get.snackbar('Error', 'Blog ID not found for deletion.', backgroundColor: Colors.red);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (blog['image_url'] != null && blog['image_url'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  blog['image_url'],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              blog['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'By ${blog['author'] ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Text(
                  '• ${blog['time_ago'] ?? 'Just now'}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              blog['content'] ?? 'No content available.',
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}