import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Still need Get for navigation and Get.put/find
import 'package:rahrisha_food/features/blog/controller/blogcontroller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_blog_screen.dart';
import 'blog_detail_screen.dart';

// lib/features/blog/view/blog_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/blog/controller/blogcontroller.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Keep this import if you still need it here, but generally, Supabase client should be handled by the controller.
import 'add_blog_screen.dart'; // Assuming you still have a separate AddBlogScreen, though we planned to rename it to AddEditBlogScreen.
import 'blog_detail_screen.dart';

mixin BlogCardBuilder {
  Widget buildBlogCard({
    required String imageUrl,
    required String title,
    required String content,
    required String author,
    required String timeAgo,
    required int blogId, // NEW: Pass the blog ID for deletion
    required VoidCallback onDelete, // NEW: Add an onDelete callback
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl.isNotEmpty
                    ? imageUrl
                    : 'https://via.placeholder.com/400x300', // fallback
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Use Expanded to prevent text overflow when delete button is present
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    maxLines: 2, // Limit lines for title
                    overflow: TextOverflow.ellipsis, // Add ellipsis
                  ),
                ),
                IconButton(
                  onPressed: onDelete, // Call the passed onDelete callback
                  icon: const Icon(Icons.delete, color: Colors.red), // Changed to delete icon
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
              maxLines: 3, // Limit lines for content preview
              overflow: TextOverflow.ellipsis, // Add ellipsis
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'By $author',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Text(
                  '• $timeAgo',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      );
}

// lib/features/blog/view/blog_screen.dart
// (Continue from the mixin above)

class BlogScreen extends StatefulWidget { // Change to StatefulWidget
  const BlogScreen({super.key});

  static const String name = '/blog';

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> with BlogCardBuilder {
  // Initialize the controller here, it's safer within StatefulWidget
  final BlogController blogController = Get.put(BlogController());

  @override
  void initState() {
    super.initState();
    // No need to call fetchBlogs here, it's called in onInit of controller
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This is a good place to refetch data when the screen comes back into view
    // (e.g., after adding, editing, or deleting a blog from another screen).
    // Ensure the controller is available before calling fetchBlogs.
    if (Get.isRegistered<BlogController>()) {
      blogController.fetchBlogs(searchQuery: blogController.searchController.text);
    }
  }

  // Helper method to show confirmation dialog and trigger deletion
  void _confirmDelete(int blogId, String title) {
    Get.defaultDialog(
      title: 'Confirm Deletion',
      middleText: 'Are you sure you want to delete "$title"? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black87,
      onConfirm: () {
        Get.back(); // Close the dialog
        blogController.deleteBlog(blogId); // Call the controller's delete method
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            // Use Get.toNamed if you've registered routes in GetMaterialApp
            // Otherwise, Get.to will work
            final bool? result = await Get.to(() => const AddBlogScreen()); // Assuming AddBlogScreen is still the name for adding
            if (result == true) {
              // If a new blog was added and the screen indicates success, refresh
              blogController.fetchBlogs();
            }
          },
          icon: const Icon(Icons.add, size: 30, color: Colors.white), // Added color for consistency
        ),
        title: GetBuilder<BlogController>(
          id: 'searchAppBar',
          builder: (controller) {
            return controller.isSearching.value
                ? TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search blogs...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.black38),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black38),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.onSearchTextChanged('');
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.amber),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              style: const TextStyle(color: Colors.black38),
              onChanged: controller.onSearchTextChanged,
              autofocus: true,
            )
                : const Text(
              'Blog',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        elevation: 0,
        actions: [
          GetBuilder<BlogController>(
            id: 'searchAppBar',
            builder: (controller) {
              return IconButton(
                onPressed: () {
                  controller.toggleSearch();
                },
                icon: Icon(
                  controller.isSearching.value ? Icons.close : Icons.search,
                  color: Colors.white, // Changed to white for visibility
                ),
              );
            },
          ),
        ],
      ),
      body: GetX<BlogController>( // Use GetX for direct reactivity to displayedBlogs
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(controller.errorMessage.value, textAlign: TextAlign.center,), // Added textAlign
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => controller.fetchBlogs(
                        searchQuery: controller.searchController.text,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (controller.displayedBlogs.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => controller.fetchBlogs(
                searchQuery: controller.searchController.text,
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 200),
                  Center(
                    child: Text(
                      controller.searchController.text.isNotEmpty && !controller.isLoading.value
                          ? 'No matching blog posts found.'
                          : 'No blog posts found.',
                    ),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => controller.fetchBlogs(
                searchQuery: controller.searchController.text,
              ),
              child: ListView.builder( // Use ListView.builder for performance
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: controller.displayedBlogs.length,
                itemBuilder: (context, index) {
                  final blog = controller.displayedBlogs[index];
                  return GestureDetector(
                    onTap: () async {
                      // Navigate to BlogDetailScreen
                      // Get.to will wait for the result if it's a Future
                      final bool? didUpdateOrDelete = await Get.to(() => BlogDetailScreen(blog: blog));
                      if (didUpdateOrDelete == true) {
                        // Refresh the list if a blog was updated or deleted from the detail screen
                        blogController.fetchBlogs();
                      }
                    },
                    child: buildBlogCard(
                      imageUrl: blog['image_url'] ?? '',
                      title: blog['title'] ?? 'No Title',
                      content: blog['content'] ?? 'No Content',
                      author: blog['author'] ?? 'Unknown Author',
                      timeAgo: blog['time_ago'] ?? 'Just now',
                      blogId: blog['id'], // Pass the blog ID
                      onDelete: () => _confirmDelete(blog['id'] as int, blog['title'] ?? 'this blog'), // Pass the delete callback
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
