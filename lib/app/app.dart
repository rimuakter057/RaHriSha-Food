import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../features/home/screens/home_screen.dart';


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
      title: 'RaHriShaFood',
        home: HomeScreen(),
      );
    }
    );
  }
}


