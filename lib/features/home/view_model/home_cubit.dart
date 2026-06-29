import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/result_firebase.dart';
import '../data/firebase/firebase_task.dart';
import '../data/model/task_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  DateTime selectedDate = DateTime.now();

  List<TaskModel> pendingTasks = [];
  List<TaskModel> completedTasks = [];

  Future<void> getTasks(DateTime date) async {
    emit(HomeLoading());

    selectedDate = date;

    final result = await FirebaseTask.getTasks(date);
    switch (result) {
      case SuccessFB<List<TaskModel>>():
        final allTasks = result.data ?? [];

        pendingTasks = allTasks
            .where((e) => e.isCompleted == false)
            .toList();

        completedTasks = allTasks
            .where((e) => e.isCompleted == true)
            .toList();

        emit(
          HomeLoaded(
            pendingTasks: pendingTasks,
            completedTasks: completedTasks,
            selectedDate: selectedDate,
          ),
        );

      case ErrorFB<List<TaskModel>>():
        emit(HomeError(result.messageError));
    }
  }

  Future<void> toggleComplete(TaskModel task) async {
    task.isCompleted = !(task.isCompleted ?? false);
    await FirebaseTask.updateIsCompleted(task);
    await getTasks(selectedDate);
  }

  Future<void> deleteTask(TaskModel task) async {
    await FirebaseTask.deleteTask(task);
    await getTasks(selectedDate);
  }

  Future<void> updateTask(TaskModel task) async {
    await FirebaseTask.updateTask(task);
    await getTasks(selectedDate);
  }

  Future<void> refresh() async {
    await getTasks(selectedDate);
  }

}