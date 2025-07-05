import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rahrisha_food/app/app_text.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _numberTEController = TextEditingController();
  final TextEditingController _bioTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(AppText.editProfile),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://scontent.fdac4-2.fna.fbcdn.net/v/t39.30808-6/294359382_1763304350685659_1729060842648557887_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=a5f93a&_nc_eui2=AeF4gQRb3G_cwGPWkiMKL79ncCB0qDdHrLhwIHSoN0esuElL5C7hrZF98Lf76n3ycgLmisIJ6_V-_Mw4ZiOHRQ53&_nc_ohc=rimwE9PRXY8Q7kNvwHQRodh&_nc_oc=AdnzWk2R47cxoDO6LaWCMK8YbH7jtAzPaMaNr1bWdJ43uV1JKrStPCG7o556GkwzfuF8CHqX0dClZfaSZ_z2sHXC&_nc_zt=23&_nc_ht=scontent.fdac4-2.fna&_nc_gid=5HRaZpbP-NF9N_KOgNnAxg&oh=00_AfPSEFOAxPVoUS4c2Z7NRRVaF9CxjgoPkYt6iV5O_f1M8A&oe=686E30DC'),
                  radius: 70.r,
                ),
                Positioned(
                  bottom: 2.sp,
                    right: 2.sp,
                    child: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.edit,color: Colors.white,),
                    )
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(24),topLeft: Radius.circular(24)),
              ),
              child: _buildSignUpForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _nameTEController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Name',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please Enter Your Name';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Text(AppText.email, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'example@gmail.com',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (String? value) {
              String email = value ?? '';
              if (!EmailValidator.validate(email)) {
                return 'Please Enter Your Email';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Text(AppText.phoneNumber, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: _numberTEController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Phone Number',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (String? value) {
              if ((value?.trim().isEmpty ?? true)) {
                return 'Please Enter You Phone Number';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Text(AppText.bio, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextFormField(
            controller: _bioTEController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'I love fast food',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (String? value) {
              if ((value?.trim().isEmpty ?? true)) {
                return 'Please Enter You Phone Number';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()){

                }
              },
              child: Text(AppText.save, style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
