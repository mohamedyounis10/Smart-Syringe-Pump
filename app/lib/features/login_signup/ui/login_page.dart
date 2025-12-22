import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../../../core/widgets/custom_button.dart';
import '../../home/cubit/logic.dart';
import '../../home/ui/main_screen.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';
import '../../../core/widgets/custom_textformfield_container.dart';

class LoginScreen extends StatelessWidget {
  // Variables
   TextEditingController email = TextEditingController();
   TextEditingController password = TextEditingController();

  // Check validation
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Object from Cubit
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
          },
            icon: Icon(Icons.arrow_back_ios , size: 25,color: AppColor.back_ground1,)),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.white,
        title: Text('Hello!',style: TextStyle(
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
              listener: (context,state){
                if(state is NextPageState){
                  Navigator.push(context, MaterialPageRoute(builder: (c){
                    return SignupScreen();
                  })
                  );
                }
                if(state is ErrorState){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Have Problem is empty'),
                      backgroundColor: AppColor.grey,
                    ),
                  );
                }
                if (state is SuccessState) {
                  // Always start from Home tab after login
                  context.read<HomeCubit>().changePage(0);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => MainScreen(),
                    ),
                  );
                }
                if (state is PasswordPageState) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c){
                        return ForgetPasswordScreen();
                      })
                  );
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
              builder: (context,state){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text - login
                    SizedBox(height: 20.h),
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.back_ground1,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Items
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            hinttext: 'example@example.com',
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
                            onChanged: cubit.updateEmail,
                          ),
                          SizedBox(height: 20.h),

                          // Password
                          // Email
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
                            hinttext: '*******',
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
                            onChanged: cubit.updatePassword,
                          ),
                          SizedBox(height: 10.h),

                          // Forget password
                          Align(
                            alignment: Alignment.topRight,
                            child:TextButton(onPressed: (){
                              cubit.PasswordPage();
                            }, child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.back_ground1,
                              ),
                            ),),),
                          SizedBox(height: 10.h),

                          // Login button
                          Center(
                            child: CustomButton(
                              text: 'LOGIN',
                              width: 390.w,
                              textColor: AppColor.white,
                              onPressed: () async {
                                // Empty
                                if(email.text.isEmpty || password.text.isEmpty){
                                  cubit.errorMessage();
                                }

                                // Check
                                if (_formKey.currentState!.validate()) {
                                  await cubit.login();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // New Account
                    Align(
                      alignment: Alignment.topRight,
                      child:TextButton(onPressed: (){
                        cubit.nextPage();
                      }, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account ?',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColor.black,
                            ),
                          ),
                          TextButton(onPressed: (){
                            cubit.nextPage();
                          }, child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.back_ground1,
                            ),
                          ),
                          )
                        ],
                      ),),),
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
