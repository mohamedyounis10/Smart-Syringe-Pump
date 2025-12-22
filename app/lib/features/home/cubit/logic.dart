import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_dose/features/home/cubit/state.dart';
import '../../../core/db/firebase.dart';
import '../../../core/mqtt_services.dart';
import '../../../models/solution_log.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {}
  final FirebaseService services = FirebaseService();
  final MqttService mqttService = MqttService.instance;

  int selectedIndex = 0; // change images

  void changePage(int index) {
    selectedIndex = index;
    emit(PageChanged(index));
  }

  Future<void> addSolutionLog({
    required String name,
    required String amount,
    required String duration,
  }) async {
    emit(HomeLoading());

    final userId = services.getCurrentUserId();
    if (userId == null) {
      emit(HomeError("User not logged in"));
      return;
    }

    try {
      await mqttService.publishSolution(amount: amount, duration: duration);

      // Listen for ESP32 status
      mqttService.listenToStatus((status) async {
        if (status == "Running...") emit(HomeRunning());
        if (status == "Finished. Ready.") {
          // Save to Firebase بعد ما يخلص
          await services.addSolutionLog(
            userId: userId,
            solutionName: name,
            amount: amount,
            duration: duration,
            loggedAt: DateTime.now(),
          );
          emit(HomeSolutionSaved());
          emit(HomeInitial());
        }
      });
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void forceStop() {
    mqttService.publishStop();
    emit(HomeStopped());
  }

  Future<void> loadSolutionLogs() async {
    emit(SolutionLogsLoading());

    try {
      final userId = services.getCurrentUserId();
      if (userId == null) {
        emit(SolutionLogsLoaded({}));
        return;
      }

      final logs = await services.getSolutionLogs(userId);
      final grouped = _groupLogsByDay(logs);

      emit(SolutionLogsLoaded(grouped));
    } catch (e) {
      emit(SolutionLogsError(e.toString()));
    }
  }

  Map<String, List<SolutionLog>> _groupLogsByDay(List<SolutionLog> logs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, List<SolutionLog>> grouped = {
      "Today": [],
      "Yesterday": [],
    };

    for (var log in logs) {
      final logDate = DateTime(log.loggedAt.year, log.loggedAt.month, log.loggedAt.day);

      if (logDate == today) {
        grouped["Today"]!.add(log);
      } else if (logDate == yesterday) {
        grouped["Yesterday"]!.add(log);
      } else {
        final formatted = DateFormat('d MMM').format(logDate);
        grouped.putIfAbsent(formatted, () => []);
        grouped[formatted]!.add(log);
      }
    }

    return grouped;
  }


}
