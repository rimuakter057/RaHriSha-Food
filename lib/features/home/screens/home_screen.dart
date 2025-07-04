import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/app/assets_path.dart';
import 'package:rahrisha_food/features/home/widgets/home_carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Image Container
            Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsPath.homeTopImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("data"),
                            DropdownButton<String>(
                              items: [],
                              onChanged: (value) {},
                              underline: Container(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                              ),
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                color: AppColors.primary,
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                              ),
                              onPressed: () {},
                              icon: Icon(
                                Icons.notifications,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          AppText.currentLocation,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    Text(
                      "Provide best food",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tab Bar
            // Tab Bar without divider and left-aligned
            Column(children: [HomeCarouselSlider()]),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
                // Remove the default divider
                dividerColor: Colors.transparent,
                // Remove left padding/indentation
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                tabAlignment: TabAlignment.start, // Force left alignment
                tabs: [
                  _buildTabItem('Home'),
                  _buildTabItem('Explore'),
                  _buildTabItem('Cart'),
                  _buildTabItem('Wishlist'),
                  _buildTabItem('Profile'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent('Home Screen Content'),
                  _buildTabContent('Explore Screen Content'),
                  _buildTabContent('Cart Screen Content'),
                  _buildTabContent('Wishlist Screen Content'),
                  _buildTabContent('Profile Screen Content'),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button with Container
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Container(
          width: double.infinity,
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Center(
            child: Text(
              'Quick Menu',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String text) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.blue,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 14.sp, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildTabContent(String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Text(text, style: TextStyle(fontSize: 18.sp)),
      ),
    );
  }
}
