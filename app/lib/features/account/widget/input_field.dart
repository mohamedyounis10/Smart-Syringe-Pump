import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';

class CustomInputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Color fillColor;
  final Color textColor;
  final int? fontSize;
  final int? maxLength;
  final TextInputType keyboardType;

  const CustomInputField({
    Key? key,
    required this.hint,
    required this.controller,
    this.maxLength,
    this.fontSize =14,
    this.fillColor = AppColor.black,
    this.textColor = AppColor.text_color2,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
        filled: true,
        fillColor: fillColor,
        hintStyle: TextStyle(color: textColor, fontSize: fontSize?.sp),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: AppColor.black, fontSize: 14.sp),
    );
  }
}
