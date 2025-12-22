import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../widget/info_card.dart';

class HelpScreen extends StatelessWidget {
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
          "Help Center",
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            InfoCard(
              title: "What is TheDose?",
              content: "TheDose is a medical syringe pump system designed to "
                  "help healthcare professionals deliver precise and controlled medication doses safely,"
                  "The app allows accurate monitoring, configuration, and tracking of infusion parameters to ensure patient safety"
            ),
            InfoCard(
              title: "How to use TheDose?",
              content: "Select the required medication and ml amount."
                  "Confirm the settings and start the infusion."
                  "Monitor real-time status and infusion history.",
            ),
            InfoCard(
              title: "Contact Us",
              content: "010000000000",
            ),
            InfoCard(
              title: "Terms & Conditions",
              content: "TheDose is intended for use by trained medical professionals only."
                  "The system must be used according to hospital protocols and clinical guidelines."
                  "The developer is not responsible for misuse, incorrect configuration, or operation outside the intended medical purpose.",
            ),
          ],
        ),
      ),
    );
  }
}