import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/blog/screen/blog_screen.dart';
import 'package:rahrisha_food/features/recepie/screens/Edit_recipe.dart';
import 'package:rahrisha_food/features/recepie/screens/recipe_details.dart';
import 'package:rahrisha_food/features/recepie/screens/upload_recipe.dart';
import 'package:rahrisha_food/features/serch/screens/search_screen.dart';
import 'package:rahrisha_food/features/wishlist/screen/wishlist_screen.dart';

class RaHriShaFood extends StatefulWidget {
  const RaHriShaFood({super.key});

  @override
  State<RaHriShaFood> createState() => _RaHriShaFoodState();
}

class _RaHriShaFoodState extends State<RaHriShaFood> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RaHriSha Food',

          theme: ThemeData(
            //this is theme data
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade100),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.infinity, 50),
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          home: SearchScreen(),
        );
      },
    );
  }
}
