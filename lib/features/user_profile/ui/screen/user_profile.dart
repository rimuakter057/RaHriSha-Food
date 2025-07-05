import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rahrisha_food/app/app_colors.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});
  static const String name='profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Personal Info',style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500
        ),),
        actions: [TextButton(
            onPressed: (){},
            child: Text('Edit',style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.orange
            ),),
        )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h,horizontal: 20.w),
        child: Column(
          children: [
          _buildProfileImage(),
            SizedBox(height: 30.h,),
            _buildContainer(),
          ],
        ),
      ),
    );
  }

  Center _buildProfileImage() {
    return Center(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://scontent.fdac4-2.fna.fbcdn.net/v/t39.30808-6/294359382_1763304350685659_1729060842648557887_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=a5f93a&_nc_eui2=AeF4gQRb3G_cwGPWkiMKL79ncCB0qDdHrLhwIHSoN0esuElL5C7hrZF98Lf76n3ycgLmisIJ6_V-_Mw4ZiOHRQ53&_nc_ohc=rimwE9PRXY8Q7kNvwHQRodh&_nc_oc=AdnzWk2R47cxoDO6LaWCMK8YbH7jtAzPaMaNr1bWdJ43uV1JKrStPCG7o556GkwzfuF8CHqX0dClZfaSZ_z2sHXC&_nc_zt=23&_nc_ht=scontent.fdac4-2.fna&_nc_gid=5HRaZpbP-NF9N_KOgNnAxg&oh=00_AfPSEFOAxPVoUS4c2Z7NRRVaF9CxjgoPkYt6iV5O_f1M8A&oe=686E30DC'),
                    radius: 60.r,
                  ),
                  SizedBox(width: 20.w,),
                  Column(
                    children: [
                      Text('Sharif Ahmed',style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600
                      ),),
                      SizedBox(height: 10.h,),
                      Text('I love fast food',style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: Colors.grey
                      ),),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
  }

  Widget _buildContainer() {
    return Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
                color: Color(0xffF6F8FA),
                borderRadius: BorderRadius.circular(15.r)
            ),
            child:Column(
              children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(FontAwesomeIcons.user,color: AppColors.secondary,),
                  ),
                  SizedBox(width: 15.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Full Name',style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600
                      ),),
                      Text('Sharif Ahmed',style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.grey[500]
                      ),)
                    ],
                  ),
                ],
              ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.email_outlined,color: Color(0xffA09EFD),),
                    ),
                    SizedBox(width: 15.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email',style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600
                        ),),
                        Text('freelancersharif69@gmail.com',style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.grey[500]
                        ),)
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(FontAwesomeIcons.phone,color: Color(0xff4FA7FF),),
                    ),
                    SizedBox(width: 15.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone Number',style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600
                        ),),
                        Text('01989815476',style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.grey[500]
                        ),)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
