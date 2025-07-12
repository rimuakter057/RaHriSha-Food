// blog_controller.dart
import 'dart:async'; // For Timer
import 'package:flutter/material.dart'; // For TextEditingController (and Get.snackbar colors)
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlogController extends GetxController {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Reactive list for blogs currently displayed (filtered or all)
  final RxList<Map<String, dynamic>> displayedBlogs = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Search related properties
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearching = false.obs; // Use RxBool because AppBar elements use it with GetBuilder
  Timer? _debounceTimer; // For debouncing search input

  @override
  void onInit() {
    super.onInit();
    print('DEBUG: BlogController onInit called. Starting fetchBlogs.');
    fetchBlogs(); // Initial fetch when the controller is created
  }

  @override
  void onClose() {
    _debounceTimer?.cancel(); // Cancel timer when controller is closed
    searchController.dispose(); // Dispose the controller
    super.onClose();
  }

  // Method to toggle search bar visibility
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      // If closing search, clear text and reset results
      searchController.clear();
      _debounceTimer?.cancel(); // Cancel any pending search
      fetchBlogs(); // Fetch all blogs again
    }
    // Call update with an ID to only rebuild the AppBar parts
    update(['searchAppBar']); // <--- Specify ID for targeted update
  }

  // Debounced search text change handler
  void onSearchTextChanged(String query) {
    _debounceTimer?.cancel(); // Cancel previous timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Only perform search if query is not empty after debounce, or if it's cleared
      fetchBlogs(searchQuery: query.trim()); // Trigger search on backend
    });
  }

  Future<void> fetchBlogs({String? searchQuery}) async {
    isLoading.value = true;
    errorMessage.value = '';
    // displayedBlogs.clear(); // Removing this as GetX builder handles updates efficiently
    update(); // <--- Call update() to rebuild UI on loading state

    print('DEBUG: fetchBlogs started. Search query: "$searchQuery"');

    try {
      var queryBuilder = _supabaseClient
          .from('blogpost') // Correct table name 'blogpost'
          .select('''
            id,
            created_at,
            image_url,
            title,
            content,
            author
          ''');

      // Apply search filter if a query is provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryBuilder = queryBuilder.or( // Use .or to search in multiple columns
          'title.ilike.%${searchQuery}%,content.ilike.%${searchQuery}%',
        );
      }

      // Order must be applied AFTER filters in Postgrest
      final List<Map<String, dynamic>> response = await queryBuilder.order('created_at', ascending: false);

      print('DEBUG: Raw Supabase response received: ${response.length} blog posts for query "$searchQuery".');

      final List<Map<String, dynamic>> processedBlogs = response.map((blogData) {
        final Map<String, dynamic> processed = Map<String, dynamic>.from(blogData);

        processed['id'] = (processed['id'] as num?)?.toInt();
        processed['title'] = processed['title'] as String? ?? 'No Title';
        processed['content'] = processed['content'] as String? ?? 'No Content';
        processed['author'] = processed['author'] as String? ?? 'Unknown Author';
        processed['image_url'] = processed['image_url'] as String? ?? 'https://via.placeholder.com/150';

        try {
          final String? createdAtString = processed['created_at'] as String?;
          if (createdAtString != null) {
            final DateTime createdAt = DateTime.parse(createdAtString);
            // Format time ago relative to the current time, which is July 12, 2025
            processed['time_ago'] = timeago.format(createdAt, locale: 'en_short');
          } else {
            processed['time_ago'] = 'N/A';
          }
        } catch (e) {
          print('WARNING: Could not parse created_at for blog ID ${processed['id']}: $e');
          processed['time_ago'] = 'N/A';
        }
        return processed;
      }).toList();

      displayedBlogs.assignAll(processedBlogs); // Update the RxList. GetX will automatically rebuild consumers.

    } on PostgrestException catch (e) {
      errorMessage.value = 'Error fetching blogs: ${e.message}';
      print('ERROR: Supabase Postgrest error fetching blogs: ${e.message}');
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: ${e.toString()}';
      print('ERROR: General error fetching blogs: ${e.toString()}');
    } finally {
      isLoading.value = false;
      update(); // <--- Call update() to rebuild UI on final state (data, error, or empty)
      print('DEBUG: fetchBlogs completed. isLoading: ${isLoading.value}');
    }
  }

  // --- NEW: Delete Blog Method ---
  Future<void> deleteBlog(int blogId) async {
    isLoading.value = true; // Show loading indicator
    update(); // Notify listeners of loading state change

    try {
      // Perform the delete operation in Supabase
      await _supabaseClient
          .from('blogpost') // Correct table name
          .delete()
          .eq('id', blogId); // Specify which blog to delete by its ID

      // Remove the deleted blog from the displayedBlogs list locally
      displayedBlogs.removeWhere((blog) => blog['id'] == blogId);

      // Show success message
      Get.snackbar(
        'Success',
        'Blog deleted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('DEBUG: Blog ID $blogId deleted successfully.');

      // Optionally, navigate back if this was called from a detail screen
      // if (Get.currentRoute == BlogDetailScreen.name) { // Assuming you have named routes
      //   Get.back(result: true); // Indicate that a change occurred
      // }

    } on PostgrestException catch (e) {
      errorMessage.value = 'Error deleting blog: ${e.message}';
      Get.snackbar(
        'Error',
        'Failed to delete blog: ${e.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('ERROR: Supabase Postgrest error deleting blog ID $blogId: ${e.message}');
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: ${e.toString()}';
      Get.snackbar(
        'Error',
        'An unexpected error occurred during deletion: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('ERROR: General error deleting blog ID $blogId: ${e.toString()}');
    } finally {
      isLoading.value = false;
      update(); // Notify listeners that loading is complete and blog list updated
    }
  }
}