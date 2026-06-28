/*
part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {}

final class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}

 */




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