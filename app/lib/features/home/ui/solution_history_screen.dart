import 'package:flutter/material.dart';
import '../../../core/app_color.dart';
import '../cubit/logic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/state.dart';

class SolutionHistoryScreen extends StatelessWidget {
  const SolutionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().loadSolutionLogs();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is SolutionLogsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SolutionLogsError) {
          return Center(child: Text(state.message));
        }

        if (state is SolutionLogsLoaded) {
          final grouped = state.groupedLogs;

          // فلترة الأقسام الفاضية
          final sections = grouped.entries.where((e) => e.value.isNotEmpty);

          if (sections.isEmpty) {
            return const Center(child: Text("No solution logs found"));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (var section in sections) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColor.text_color2.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        section.key,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.text_color2,
                        ),
                      ),
                    ),
                  ),
                ),

                ...section.value.map((log) {
                  final time = DateFormat('HH:mm').format(log.loggedAt);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.solutionName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text("amount: ${log.amount} ml"),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              time,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 3),
                            Text("duration: ${log.duration} sec"),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ]
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
