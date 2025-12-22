import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../../../core/widgets/custom_button.dart';
import '../../account/ui/terms_conditions.dart';
import '../../home/ui/main_screen.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';
import '../../../core/widgets/custom_textformfield_container.dart';

class SignupScreen extends StatelessWidget {
  // Variables
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();


  // Check validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Object from Cubit
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          cubit.returnPage();
        },
            icon: Icon(Icons.arrow_back_ios , size: 25,color: AppColor.back_ground1,)),
        backgroundColor: AppColor.white,
        title: Text('New Account',style: TextStyle(
            color: AppColor.text_color2,
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.all(20.0.w),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is SuccessState) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => MainScreen(),
                    ),
                  );
                }
                if (state is ReturnPageState) {
                  Navigator.of(context).pop();
                }
                if (state is FailureState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: AppColor.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Items
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Full name
                          Text(
                            'Full name',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          CustomTextFormFieldContainer(
                            controller: name,
                            hinttext: 'Name',
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),

                          // Email
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          CustomTextFormFieldContainer(
                            controller: email,
                            hinttext: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value.trim())) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),

                          // Password
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          CustomTextFormFieldContainer(
                            controller: password,
                            hinttext: 'Password',
                            obscureText: cubit.isObscure,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                cubit.isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColor.grey,
                              ),
                              onPressed: cubit.togglePasswordVisibility,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),

                          // Password
                          Text(
                            'Mobile Number',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                            ),
                          ),
                          CustomTextFormFieldContainer(
                            controller: phone,
                            hinttext: '011********',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 1.h),

                          Row(
                            children: [
                              Checkbox(value: cubit.isChecked,
                                  activeColor: AppColor.back_ground1,
                                  onChanged: (v) {
                                cubit.checkBox();
                              }),
                              Text(
                                'I accepted',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColor.black,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (c){
                                      return TermsScreen();
                                    })
                                  );
                                },
                                child: Text(
                                  ' Terms & Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.back_ground1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Sign Up button
                          Center(
                            child: CustomButton(
                              text: 'Sign Up',
                              width: 300.w,
                              textColor: AppColor.white,
                              onPressed: () async {
                                if (email.text.isEmpty ||
                                    password.text.isEmpty ||
                                    name.text.isEmpty || cubit.isChecked== false) {
                                  cubit.errorMessage();
                                }
                                if (_formKey.currentState!.validate()) {
                                  await cubit.signup(
                                    name: name.text.trim(),
                                    email: email.text.trim(),
                                    password: password.text.trim(),
                                    phone: phone.text.trim()
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),

                    // Social Media
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColor.border_color,
                                thickness: 2.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Text(
                                'Or sign in with',
                                style: TextStyle(
                                  color: AppColor.border_color,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColor.border_color,
                                thickness: 2.h,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.h),

                      ],
                    ),
                    SizedBox(height: 5.h),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          cubit.returnPage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account ?',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),
                            Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.back_ground1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
