import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textformfield_container.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';

class DetailsScreen extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: AppColor.success,
            ),
          );

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context);
          });

        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: AppColor.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          name.text = state.user.name;
          email.text = state.user.email;
          phone.text = state.user.phoneNumber ?? "";
        }

        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColor.text_color2, size: 22.sp),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Account Details",
              style: TextStyle(
                color: AppColor.text_color2,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColor.white,
          ),
          body: state is ProfileLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                CustomTextFormFieldContainer(
                  controller: name,
                  hinttext: "Full Name",
                ),
                SizedBox(height: 16.h),
                CustomTextFormFieldContainer(
                  controller: email,
                  hinttext: "Email",
                ),
                SizedBox(height: 16.h),
                CustomTextFormFieldContainer(
                  controller: phone,
                  hinttext: "Phone Number",
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  width: 343,
                  text: state is ProfileLoading ? 'Saving...' : 'Edit',
                  textColor: AppColor.white,
                  onPressed: () {
                    context.read<ProfileCubit>().updateProfile(
                      name: name.text,
                      email: email.text,
                      phone: phone.text,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
