import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rahrisha_food/features/recepie/screens/Edit_recipe.dart';
import 'package:rahrisha_food/features/recepie/screens/recipe_details.dart';
import 'package:rahrisha_food/features/recepie/screens/upload_recipe.dart';


class RaHriShaFood extends StatefulWidget {
  const RaHriShaFood({super.key});

  @override
  State<RaHriShaFood> createState() => _RaHriShaFoodState();
}

class _RaHriShaFoodState extends State<RaHriShaFood> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade100)
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(double.infinity, 50),
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            )
          )
        )
      ),
      //home: RecipeDetailPage(),
    );
  }
}


