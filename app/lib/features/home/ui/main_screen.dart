import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_dose/features/home/ui/info_screen.dart';
import 'package:the_dose/features/home/ui/solution_history_screen.dart';
import '../../../core/app_color.dart';
import '../../account/ui/profile_screen.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';
import '../widget/nav_item.dart';
import 'home_screen.dart';

class MainScreen extends StatelessWidget {
  // Pages
  final List<Widget> _pages = [
    HomeScreen(),
    InfoScreen(),
    ProfileScreen(),
    SolutionHistoryScreen(),
  ];

  // AppBars
  AppBar? buildAppBar(int index, BuildContext context) {
    switch(index) {
      case 0:
        return null;
      case 1:
        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColor.text_color2, size: 22.sp),
            onPressed: () => context.read<HomeCubit>().changePage(0),
          ),
          title: Text(
            "Info",
            style: TextStyle(
              color: AppColor.text_color2,
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.white,
        );
      case 2:
        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColor.text_color2, size: 22.sp),
            onPressed: () => context.read<HomeCubit>().changePage(0),
          ),
          title: Text(
            "My Account",
            style: TextStyle(
              color: AppColor.text_color2,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.white,
        );
      default:
        return AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColor.text_color2, size: 22.sp),
            onPressed: () => context.read<HomeCubit>().changePage(0),
          ),
          title: Text(
            "History",
            style: TextStyle(
              color: AppColor.text_color2,
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.white,
        );;
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, currentIndex) {
        final cubit = context.read<HomeCubit>();
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: buildAppBar(cubit.selectedIndex, context),
          body: _pages[cubit.selectedIndex],
          bottomNavigationBar: Padding(
            padding:  EdgeInsets.all(20),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: AppColor.text_color2,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: buildNavItem(
                        icon: Icons.home_outlined,
                        isSelected: cubit.selectedIndex == 0,
                        onTap: () { cubit.changePage(0); },
                      ),
                    ),
                    Expanded(
                      child: buildNavItem(
                        icon: Icons.info_outline,
                        isSelected: cubit.selectedIndex == 1,
                        onTap: () { cubit.changePage(1); },
                      ),
                    ),
                    Expanded(
                      child: buildNavItem(
                        icon: Icons.person_outline,
                        isSelected: cubit.selectedIndex == 2,
                        onTap: () { cubit.changePage(2); },
                      ),
                    ),
                    Expanded(
                      child: buildNavItem(
                        icon: Icons.calendar_today_outlined,
                        isSelected: cubit.selectedIndex == 3,
                        onTap: () { cubit.changePage(3); },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
