import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/app_text.dart';
import 'package:rahrisha_food/app/assets_path.dart';
import 'package:rahrisha_food/features/home/screens/widget/carousel_slider.dart';
import 'package:rahrisha_food/features/recepie/screens/recipe_details.dart';
import 'package:rahrisha_food/features/recepie/screens/upload_recipe.dart';
import 'package:rahrisha_food/features/serch/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String name='sign_in';
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
                            Text("location",style: TextStyle(color: AppColors.white),),
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
                              onPressed: () {
                                Get.toNamed(SearchScreen.name);
                              },
                              icon: Icon(
                                  Icons.search,
                                  color: AppColors.white
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                shape: const CircleBorder(),
                              ),
                              onPressed: () {},
                              icon: Icon(
                                  Icons.notifications,
                                  color: AppColors.white
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16.sp,color: AppColors.white),
                        SizedBox(width: 4.w),
                        Text(
                          AppText.currentLocation,
                          style: TextStyle(fontSize: 12.sp,color: AppColors.white),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            HomeCarouselSlider(),
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
                      height: 180.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listItems.length,
                        itemBuilder: (context, index) {
                          return FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 180.w,
                                    height: 100.h,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      image: DecorationImage(
                                        image: AssetImage(AssetsPath.homeTopImage), // তোমার ইমেজ পাথ
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "title",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "subtitle",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                        dividerColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        tabAlignment: TabAlignment.start, // Force left alignment
                        tabs: [
                          _buildTabItem('Burgers'),
                          _buildTabItem('Pizza'),
                          _buildTabItem('Rice'),
                          _buildTabItem('Noodles'),
                          _buildTabItem('Desserts'),
                          _buildTabItem('Drinks'),
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
                          _buildTabContent('Pizza6'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: (){},
            child: Icon(Icons.add,color: AppColors.white,size: 30.sp,),
      )
    );
  }
  Widget _buildTabItem(String text) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: AppColors.primary,
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
        return GestureDetector(
          onTap: (){
            Get.toNamed(RecipeDetailPage.name);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                      child: Image.asset(
                        AssetsPath.homeTopImage,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Favorite Icon Positioned on top left
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.favorite, color: Colors.white),
                          onPressed: () {

                          },
                          iconSize: 24,
                        ),
                      ),
                    ),
                  ],
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
                         RatingBarIndicator(
                            rating: 4.5,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 3,
                            itemSize: 15.sp,
                            direction: Axis.horizontal,
                          ),
                          Text(
                            "Review",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "(12)",
                            style: TextStyle(fontSize: 8.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        );
      },
    );
  }
}