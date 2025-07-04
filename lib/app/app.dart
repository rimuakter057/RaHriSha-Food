import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';


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
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
                fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white
            ),
            titleSmall: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp
            ),
          ),
        ),
      debugShowCheckedModeBanner: false,
      title: 'RaHriShaFood',
      );
    }
    );
  }
}


