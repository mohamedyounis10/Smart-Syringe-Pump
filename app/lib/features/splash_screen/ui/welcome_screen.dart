import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_dose/core/widgets/custom_button.dart';
import 'package:the_dose/features/login_signup/ui/login_page.dart';
import '../../../core/app_color.dart';
import '../../login_signup/ui/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Spacer(flex: 2),
            Center(
              child: Image.asset(
                'assets/images/img_2.png',
                width: 250.w,
                height: 250.h,
              ),
            ),
            Spacer(flex: 1),
            CustomButton(
              width: 170.w,
              height: 40.h,
              text: 'Log In',
              textColor: AppColor.text_color1,
              fontSize: 16.sp,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c){
                  return LoginScreen();
                })
                );
              },
            ),
            SizedBox(height: 10.h),
            CustomButton(
              width: 170.w,
              height: 40.h,
              text: 'Sign Up',
              backgroundColor: AppColor.back_ground3,
              textColor: AppColor.back_ground1,
              fontSize: 16.sp,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c){
                  return SignupScreen();
                })
                );
              },
            ),

            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
