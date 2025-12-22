import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dose/features/account/ui/password_screen.dart';
import 'package:the_dose/features/account/ui/terms_conditions.dart';
import 'package:the_dose/features/splash_screen/ui/welcome_screen.dart';
import '../../../core/app_color.dart';
import '../../login_signup/cubit/logic.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';
import 'details_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        final Map<String, WidgetBuilder> routes = {
          'account': (_) => DetailsScreen(),
          'security': (_) => PasswordScreen(),
          'privacy': (_) => TermsScreen(),
          'contact': (_) => HelpScreen(),
        };
        List<Map<String, dynamic>> generalItems = [
          {
            "icon": Icons.person_outline,
            "title": "Account Details",
            "subtitle": 'Edit your account information',
            "onTap": () {
              Navigator.push(context, MaterialPageRoute(builder: routes['account']!));
            },
          },
          {
            "icon": Icons.lock_outline,
            "title": "Security & Password",
            "subtitle": "Edit your password",
            "onTap": () {
              Navigator.push(context, MaterialPageRoute(builder: routes['security']!));
            },
          },
        ];
        List<Map<String, dynamic>> settingItems = [
          {
            "icon": Icons.privacy_tip_outlined,
            "title": "Privacy & Policy",
            "onTap": () {
              Navigator.push(context, MaterialPageRoute(builder: routes['privacy']!));
            },
          },
          {
            "icon": Icons.phone_outlined,
            "title": "Contact Us",
            "onTap": () {
              Navigator.push(context, MaterialPageRoute(builder: routes['contact']!));
            },
          },
        ];
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProfileError) {
          return Center(child: Text(state.message));
        }

        return ListView(
          children: [
            // General Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                "General",
                style: TextStyle(
                  color: AppColor.text_color2,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: generalItems.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final item = generalItems[index];
                return ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.grey400,
                        width: 1.5.w,
                      ),
                    ),
                    child: Icon(
                      item["icon"],
                      color: AppColor.text_color2,
                      size: 22.sp,
                    ),
                  ),
                  title: Text(
                    item["title"],
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16.sp),
                  ),
                  subtitle: item["subtitle"] != null
                      ? Text(
                    item["subtitle"],
                    style:
                    TextStyle(color: AppColor.grey, fontSize: 14.sp),
                  )
                      : null,
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16.sp, color: AppColor.grey),
                  onTap: item["onTap"],
                );
              },
            ),
            const Divider(),

            // Settings Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                "Settings",
                style: TextStyle(
                  color: AppColor.text_color2,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: settingItems.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final item = settingItems[index];
                return ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.grey400,
                        width: 1.5.w,
                      ),
                    ),
                    child: Icon(
                      item["icon"],
                      color: AppColor.text_color2,
                      size: 22.sp,
                    ),
                  ),
                  title: Text(
                    item["title"],
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16.sp),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16.sp, color: AppColor.grey),
                  onTap: item["onTap"],
                );
              },
            ),
            const Divider(),

            SizedBox(height: 30.h),

            // Logout
            Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: ()async{
                    await context.read<AuthCubit>().logout();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => WelcomeScreen()),
                          (route) => false,
                    );
                  },
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                        color: AppColor.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }
}
