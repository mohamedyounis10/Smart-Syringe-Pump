import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.text_color2, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Terms & Conditions",
          style: TextStyle(
            color: AppColor.text_color2,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Last update: 17/2/2023',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColor.grey500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please read these terms of service, carefully before using our app operated by us.',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            SizedBox(height: 24.h),

            // Conditions
            Text(
              'Conditions of Uses',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            SizedBox(height: 16.h),

            // Big text
            Text(
              'It is a long established fact that a reader will be distracted by the'
                  ' readable content of a page when looking at its layout. The point'
                  ' of using Lorem Ipsum is that it has a more-or-less normal distribution '
                  'of letters, as opposed to using \'Content here, content here making it'
                  ' look like readable English. Many desktop publishing packages and web '
                  'page editors now use Lorem Ipsum as their default model text, and a '
                  'search for \'lorem ipsum\' will uncover many web sites still in their'
                  ' infancy. Various versions have evolved over the years, sometimes by '
                  'accident, sometimes on purpose (injected humour and the like).',
              style: TextStyle(fontSize: 16.sp, height: 1.5),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
