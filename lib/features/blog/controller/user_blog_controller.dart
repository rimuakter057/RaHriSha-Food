import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserBlogsController extends GetxController {
  final isLoading = true.obs;
  final RxList<dynamic> myBlogs = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('[UserBlogsController] onInit called');
    fetchMyBlogs();
  }

  Future<void> fetchMyBlogs() async {
    try {
      isLoading(true);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      debugPrint('[UserBlogsController] Current user ID: $userId');

      if (userId == null) {
        debugPrint('[UserBlogsController] ERROR: userId is null!');
        Get.snackbar('Error', 'User is not authenticated.');
        return;
      }

      final response = await Supabase.instance.client
          .from('blogpost')
          .select()
          .eq('user_id', userId);

      for (var blog in response) {
        debugPrint('  Blog: ${blog['id']} | ${blog['title']}');
      }

      myBlogs.assignAll(response);
      update();
    } catch (e, st) {
      debugPrint('[UserBlogsController] fetchMyBlogs ERROR: $e');
      debugPrintStack(stackTrace: st);
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
      debugPrint('[UserBlogsController] isLoading set to false');
    }
  }

  Future<void> deleteBlog(int blogId) async {
    debugPrint('[UserBlogsController] Deleting blog ID: $blogId');

    try {
      final response = await Supabase.instance.client
          .from('blogpost')
          .delete()
          .eq('id', blogId);

      debugPrint('[UserBlogsController] Delete response: $response');

      // Re-fetch after deletion
      fetchMyBlogs();
    } catch (e, st) {
      debugPrint('[UserBlogsController] deleteBlog ERROR: $e');
      debugPrintStack(stackTrace: st);
      Get.snackbar('Error', e.toString());
    }
  }
}
