import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios)),
        title: const Text(
          'Foodie Blog',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            blogCard(
              imageUrl: 'https://i.ibb.co/HfN9KPM8/FRAME-5.png',
              title: 'The Ultimate Guide to Food Photography',
              content:
              'Master the art of capturing your favorite dishes with these professional tips and techniques. Learn about lighting, composition, and editing...',
              author: 'Sarah Chen',
              timeAgo: '2 days ago',
            ),
            blogCard(
              imageUrl: 'https://i.ibb.co/kVLqvGBQ/FRAME-4.png',
              title: 'Healthy Eating: Tips from Top Chefs',
              content:
              'Discover how celebrity chefs maintain their healthy diets while working in the kitchen. Expert advice on balancing nutrition with flavor...',
              author: 'Michael Rodriguez',
              timeAgo: '3 days ago',
            ),
            blogCard(
              imageUrl: 'https://i.ibb.co/HfN9KPM8/FRAME-5.png',
              title: 'The Ultimate Guide to Food Photography',
              content:
              'Master the art of capturing your favorite dishes with these professional tips and techniques. Learn about lighting, composition, and editing...',
              author: 'Sarah Chen',
              timeAgo: '2 days ago',
            ),

            blogCard(
              imageUrl: 'https://i.ibb.co/HfN9KPM8/FRAME-5.png',
              title: 'The Ultimate Guide to Food Photography',
              content:
              'Master the art of capturing your favorite dishes with these professional tips and techniques. Learn about lighting, composition, and editing...',
              author: 'Sarah Chen',
              timeAgo: '2 days ago',
            ),

          ],
        ),
      ),
    );
  }

  /// ✅ Blog card function with image
  Widget blogCard({
    required String imageUrl,
    required String title,
    required String content,
    required String author,
    required String timeAgo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'By $author',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '• $timeAgo',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
