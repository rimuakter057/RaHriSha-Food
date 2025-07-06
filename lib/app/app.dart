import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/app/app_colors.dart';
import 'package:rahrisha_food/app/controller_binder.dart';

import 'package:rahrisha_food/features/auth/ui/screens/splash_screen.dart';
import '../features/auth/ui/screens/sign_in_screen.dart';
import '../features/common/ui/screens/main_bottom_nav_screen.dart';
import 'app_routes.dart';


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
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          initialRoute: SplashScreen.name,
          onGenerateRoute: AppRoutes.onGenerateRoute,
initialBinding: ControllerBinder(),

        );
      },
    );
  }
}
