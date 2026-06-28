
import '../data/model/task_model.dart';
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TaskModel> pendingTasks;
  final List<TaskModel> completedTasks;
  final DateTime selectedDate;

  HomeLoaded({
    required this.pendingTasks,
    required this.completedTasks,
    required this.selectedDate,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}