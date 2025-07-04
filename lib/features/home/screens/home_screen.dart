import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/app/assets_path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<String> listItems = List.generate(20, (index) => 'List Item ${index + 1}');
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
            // Top Fixed Container (Non-scrolling)
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

            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured Items ListView
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        'Featured Items',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listItems.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 150.w,
                            margin: EdgeInsets.only(
                              left: 16.w,
                              right: index == listItems.length - 1 ? 16.w : 0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                listItems[index],
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Tab Bar

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
                    // TabBarView Content
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTabContent("Pizza1"),
                          _buildTabContent('Pizza2'),
                          _buildTabContent("Pizza3"),
                          _buildTabContent('Pizza4'),
                          _buildTabContent('Pizza5'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Container(
          width: 120.w,
          height: 60.h,
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
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: Image.asset(
                    AssetsPath.homeTopImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          "Review",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.star, size: 16.sp, color: Colors.amber),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}




// Container(
// padding: EdgeInsets.symmetric(vertical: 8.h),
// child: TabBar(
// controller: _tabController,
// isScrollable: true,
// labelColor: Colors.white,
// unselectedLabelColor: Colors.white70,
// indicatorColor: Colors.black,
// labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
// // Remove the default divider
// dividerColor: Colors.transparent,
// // Remove left padding/indentation
// padding: EdgeInsets.zero,
// indicatorPadding: EdgeInsets.zero,
// tabAlignment: TabAlignment.start, // Force left alignment
// tabs: [
// _buildTabItem('Home'),
// _buildTabItem('Explore'),
// _buildTabItem('Cart'),
// _buildTabItem('Wishlist'),
// _buildTabItem('Profile'),
// ],
// ),
// ),