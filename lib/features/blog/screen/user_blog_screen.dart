import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/blog/controller/user_blog_controller.dart';
import 'package:rahrisha_food/features/common/widgets/dialog.dart';
import 'add_blog_screen.dart';

class UserBlogsScreen extends StatefulWidget {
  const UserBlogsScreen({super.key});

  @override
  State<UserBlogsScreen> createState() => _UserBlogsScreenState();
}

class _UserBlogsScreenState extends State<UserBlogsScreen> {
  final controller = Get.put(UserBlogsController());
  final _scrollController = ScrollController();
  double _cardElevation = 4.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _confirmDelete(int blogId, String title) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Blog', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this blog?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Get.back();
              controller.deleteBlog(blogId);
              showSuccessDialog(
                title: 'Blog Deleted',
                icon: Icons.delete,
                iconColor: Colors.red,
                message: 'You have successfully deleted the blog.',
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Blogs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: _buildAppBarBackground(),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(const AddBlogScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return _buildLoading(primary, theme);
        if (controller.myBlogs.isEmpty) return _buildEmptyState(theme, primary);

        return RefreshIndicator(
          color: primary,
          onRefresh: controller.fetchMyBlogs,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: controller.myBlogs.length,
            itemBuilder: (_, i) => _buildBlogCard(controller.myBlogs[i], theme),
          ),
        );
      }),
    );
  }

  Widget _buildAppBarBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: const Border(
          bottom: BorderSide(color: Colors.amber, width: 2),
          left: BorderSide(color: Colors.amber, width: 1),
          right: BorderSide(color: Colors.amber, width: 1),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
    );
  }

  Widget _buildLoading(Color primary, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(primary)),
          const SizedBox(height: 16),
          Text('Loading your blogs...', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, Color primary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No blogs yet', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Start by creating your first blog post',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.to(const AddBlogScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('CREATE BLOG'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(Map<String, dynamic> blog, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _cardElevation = 8),
      onExit: (_) => setState(() => _cardElevation = 4),
      child: GestureDetector(
        onTap: () {}, // TODO: Add navigation logic
        child: Card(
          elevation: _cardElevation,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(blog, isDark),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog['content'] ?? 'No content',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('By ${blog['author'] ?? 'Unknown'}',
                            style: theme.textTheme.bodySmall),
                        Text(blog['time_ago'] ?? '',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(Map<String, dynamic> blog, bool isDark) {
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          child: blog['image_url']?.isNotEmpty == true
              ? Image.network(
            blog['image_url'],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
          )
              : _buildPlaceholderImage(),
        ),
        Container(
          height: 180,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _confirmDelete(blog['id'], blog['title']),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline,
                  color: Colors.white, size: 20),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Text(
            blog['title'] ?? 'Untitled Blog',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 6, color: Colors.black)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return const Center(
      child: Icon(Icons.article_outlined, size: 60, color: Colors.grey),
    );
  }
}
