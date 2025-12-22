import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dose/features/login_signup/ui/signup_screen.dart';
import '../../../core/app_color.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textformfield_container.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.white,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios , size: 25,color: AppColor.back_ground1,)),
        title: Text('Forget Password',style: TextStyle(
            color: AppColor.text_color2,
            fontSize: 28,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: BlocConsumer<AuthCubit, AuthState>(
           listener: (context, state) {

            if (state is ResetPasswordSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset link sent!'),
                  backgroundColor: AppColor.success,
                ),
              );
              Navigator.of(context).pop();
            }

            if (state is ResetPasswordFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColor.error,
                ),
              );
            }

            if (state is RedirectToSignupState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Email not found. Redirecting to Signup..."),
                  backgroundColor: Colors.orange,
                ),
              );

              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (c){
                    return SignupScreen();
                  })
                );
              });
            }

          },
            builder: (context, state) {
            final cubit = context.read<AuthCubit>();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    'Enter your email address to receive a password reset link.',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColor.black,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Email Input
                  CustomTextFormFieldContainer(
                    controller: emailController,
                    hinttext: 'Enter your email',
                    suffixIcon: Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 30.h),

                  // Confirm Button
                  Center(
                    child: state is LoadingState
                        ? CircularProgressIndicator(color: AppColor.text_color2)
                        : CustomButton(
                      text: 'Send Reset Link',
                      width: 300.w,
                      textColor: AppColor.white,
                      onPressed: () {
                        final email = emailController.text.trim();
                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter your email'),
                              backgroundColor: AppColor.error,
                            ),
                          );
                          return;
                        }
                        cubit.resetPassword(email);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
