import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_color.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textformfield_container.dart';
import '../../account/cubit/logic.dart';
import '../../account/cubit/state.dart';
import '../cubit/logic.dart';
import '../cubit/state.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController ml = TextEditingController();
  final TextEditingController time = TextEditingController();
  final TextEditingController solutionController = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool isOpen = false;

  final List<String> solutions = const [
    "Normal Saline (0.9% NaCl)",
    "Hypotonic Saline (0.45% NaCl)",
    "Hypertonic Saline (3% NaCl)",
    "Balanced Salt Solutions (BSS)",
    "Nasal Rinses/Sprays",
    "Dextrose Solutions (D5W)",
    "Ringer's Lactate (LR)",
    "Glucose-Electrolyte Solutions"
  ];
  double progressValue = 0.0;
  Timer? _timer;

  void startProgress(int totalSec) {
    _timer?.cancel();
    progressValue = 0.0;
    const tick = Duration(milliseconds: 100);
    int elapsed = 0;

    _timer = Timer.periodic(tick, (timer) {
      elapsed += tick.inMilliseconds;
      setState(() {
        progressValue = (elapsed / (totalSec * 1000)).clamp(0.0, 1.0);
      });
      if (progressValue >= 1.0) timer.cancel();
    });
  }
  void stopProgress() {
    _timer?.cancel();
    setState(() => progressValue = 0.0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _removeOverlay() {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
      isOpen = false;
    }
    void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 48,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 55),
          showWhenUnlinked: false,
          child: Material(
            color: AppColor.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: solutions.map((name) {
                return ListTile(
                  title: Text(name),
                  onTap: () {
                    solutionController.text = name;
                    _removeOverlay();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

      Overlay.of(context).insert(_overlayEntry!);
      isOpen = true;
    }

    return SafeArea(
        child: BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)));
            }
            if (state is HomeSolutionSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to history')));
            }
            if (state is HomeRunning) {
              final totalSec = int.tryParse(time.text.trim()) ?? 0;
              if (totalSec > 0) startProgress(totalSec);
            }
            if (state is HomeStopped) stopProgress();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    String username = "User";

                    if (state is ProfileLoaded) {
                      username = state.user.name ?? "User";
                    } else if (state is ProfileUpdated) {
                      username = state.user.name ?? "User";
                    }

                    return Row(
                      children: [
                         CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColor.text_color2.withOpacity(0.15),
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: AppColor.text_color2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, Welcome Back",
                              style: TextStyle(
                                color: AppColor.text_color2,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),

              // Amount
              Text(
                'Amount',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
                CustomTextFormFieldContainer(
                  controller: ml,
                  hinttext: 'Ex: 2 - Max 3',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your amount';
                    }
                    int? numValue = int.tryParse(value.trim());
                    if (numValue == null) return 'Please enter a valid number';
                    if (numValue > 3) return 'Value cannot be more than 3';
                    return null;
                  },
                ),
                SizedBox(height: 10.h),

              // Duration
              Text(
                'Duration',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              CustomTextFormFieldContainer(
                controller: time,
                hinttext: 'Time in sec',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return 'Please enter your duration';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.h),

              // Solution
              Text(
                'Solution',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              CompositedTransformTarget(
                link: _layerLink,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColor.back_ground3,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: solutionController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Select Solution",
                            hintStyle:TextStyle(
                              color: AppColor.text_color2
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          if (isOpen) {
                            _removeOverlay();
                          } else {
                            _showOverlay();
                          }
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.blue.shade900,
                          child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Progress Indicator
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progressValue,
                          strokeWidth: 20,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressValue == 0.0 ? Colors.grey : Colors.teal,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

              // button - Start
                Center(
                  child: CustomButton(
                    text: 'Start',
                    width: 300.w,
                    height: 35.h,
                    textColor: AppColor.white,
                    onPressed: () async {
                      if (solutionController.text.trim().isEmpty ||
                          ml.text.trim().isEmpty ||
                          time.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fill solution, amount, duration')));
                        return;
                      }

                      int? amountValue = int.tryParse(ml.text.trim());
                      if (amountValue == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid number for Amount')));
                        return;
                      }
                      if (amountValue > 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Amount cannot be more than 3')));
                        return;
                      }

                      await context.read<HomeCubit>().addSolutionLog(
                        name: solutionController.text.trim(),
                        amount: ml.text.trim(),
                        duration: time.text.trim(),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15.h),

            ],
          ),
        ),
        )
    );
  }
}

