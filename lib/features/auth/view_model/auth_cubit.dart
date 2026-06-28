import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskey_app/core/network/result_firebase.dart';
import 'package:taskey_app/core/utils/show_welcome_notification.dart';
import '../../home/data/firebase/firebase_task.dart';
import '../../home/data/model/task_model.dart';
import '../data/firebase/firebase_database_user.dart';
import '../data/model/user_model.dart';

part 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await FBAUser.loginUser(
      email: email,
      password: password,
    );

    switch (result) {
      case SuccessFB<UserCredential>():
        await _showUserNotification();
        emit(LoginSuccess());

      case ErrorFB<UserCredential>():
        emit(AuthError(result.messageError));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await FBAUser.registerUser(
      UserModel(
        name: name,
        email: email,
        password: password,
      ),
    );

    switch (result) {
      case SuccessFB<UserModel>():
        emit(RegisterSuccess());

      case ErrorFB<UserModel>():
        emit(AuthError(result.messageError));
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    emit(LogoutSuccess());
  }

  Future<void> _showUserNotification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    String userName = 'Taskey User';

    final nameResult = await FBAUser.getUserName(user.uid);

    if (nameResult is SuccessFB<String>) {
      userName = nameResult.data ?? 'Taskey User';
    }

    final taskResult = await FirebaseTask.getTasks(DateTime.now());

    if (taskResult is SuccessFB<List<TaskModel>>) {
      final tasks = taskResult.data ?? [];

      final pendingTasks = tasks
          .where((task) => task.isCompleted == false)
          .length;

      await showWelcomeNotification(
        userName: userName,
        totalTasksCount: tasks.length,
        pendingTasksCount: pendingTasks,
      );
    }
  }
}