import '../../../models/solution_log.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeSolutionSaved extends HomeState {}

class SolutionLogsInitial extends HomeState {}

class SolutionLogsLoading extends HomeState {}

class SolutionLogsLoaded extends HomeState {
  final Map<String, List<SolutionLog>> groupedLogs;
  SolutionLogsLoaded(this.groupedLogs);
}

class HomeRunning extends HomeState {}
class HomeStopped extends HomeState {}

class SolutionLogsError extends HomeState {
  final String message;
  SolutionLogsError(this.message);
}

class PageChanged extends HomeState {
  final int index;
  PageChanged(this.index);
}
