import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_color.dart';

class CustomTextFormFieldContainer extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final bool obscureText;
  final int width;
  final int hight;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextFormFieldContainer({
    Key? key,
    required this.controller,
    required this.hinttext,
    this.obscureText = false,
    this.suffixIcon,
    this.width =380,
    this.hight = 50,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: hight.h,
      decoration: BoxDecoration(
        color: AppColor.back_ground3,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hinttext,
          hintStyle: TextStyle(
            color: AppColor.back_ground1,
            fontSize: 14.sp,
          ),
          
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 20.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColor.border_color,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color:  AppColor.back_ground3,
              width: 2,
            ),
          ),
        ),

      ),
    );
  }
}


