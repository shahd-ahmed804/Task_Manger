import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskey_app/auth/view/register_screen.dart';
import 'package:taskey_app/const.dart';
import 'package:taskey_app/auth/data/firebase/firebase_database_user.dart';
import 'package:taskey_app/core/network/result_firebase.dart';
import 'package:taskey_app/auth/widgets/inkwell_widget.dart';
import 'package:taskey_app/auth/widgets/text_form_feild_widget.dart';
import 'package:taskey_app/core/utils/app_dialog.dart';
import 'package:taskey_app/core/utils/valditor.dart';
import 'package:taskey_app/home/data/firebase/firebase_task.dart';
import 'package:taskey_app/home/data/model/task_model.dart';
import 'package:taskey_app/core/utils/show_welcome_notification.dart';
import 'package:taskey_app/main_layout.dart';

import '../../home/view/home_screen.dart';
import '../view_model/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email = TextEditingController();
  var password = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          AppDialog.showLoading(context);
        }
        if (state is LoginSuccess) {
          Navigator.pop(context);

          email.clear();
          password.clear();

          Navigator.pushReplacementNamed(
            context,
            MainLayout.routeName,
          );
        }
        if (state is AuthError) {
          Navigator.pop(context);

          AppDialog.showError(
            context,
            error: state.message,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 122),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 53),
                  Text(
                    'email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormFieldWidget(
                    controller: email,
                    validator: Validator.validateEmail,
                    hintText: 'enter email',
                  ),
                  SizedBox(height: 26),
                  Text(
                    'password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff404147),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormFieldWidget(
                    controller: password,
                    validator: Validator.validatePassword,
                    hintText: 'password',
                    isPassword: true,
                    obscureText: true,
                  ),
                  SizedBox(height: 71),
                  MaterialButton(
                    onPressed: onPressedLogin,
                    color: themeColor,
                    minWidth: double.infinity,
                    height: 48,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: InKWellWidget(
            title: 'Don’t have an account? ',
            subTitle: 'Register',
            routePath: RegisterScreen.routeName,
          ),
        );
      },
    );
  }
   onPressedLogin() {
  if (formKey.currentState!.validate()) {
  context.read<AuthCubit>().login(
  email: email.text,
  password: password.text,
  );
  }
  }
/*
  void onPressedLogin() async {
    if (formKey.currentState!.validate()) {
      AppDialog.showLoading(context);
      final result = await FBAUser.loginUser(
        email: email.text,
        password: password.text,
      );
      Navigator.of(context).pop();
      switch (result) {
        case SuccessFB<UserCredential>():
          final user = FirebaseAuth.instance.currentUser;
          String userName = 'Taskey User';
          if (user != null) {
            final nameResult = await FBAUser.getUserName(user.uid);

            if (nameResult is SuccessFB<String>) {
              userName = nameResult.data!;
            }
          }
          DateTime today = DateTime.now();
          final tasksResult = await FirebaseTask.getTasks(today);
          if (tasksResult is SuccessFB<List<TaskModel>>) {
            final allTasksToday = tasksResult.data ?? [];
            final totalTasksCount = allTasksToday.length;
            final pendingTasksCount = allTasksToday
                .where((task) => task.isCompleted == false)
                .length;
            await showWelcomeNotification(
              userName: userName,
              totalTasksCount: totalTasksCount,
              pendingTasksCount: pendingTasksCount,
            );
          }
          email.clear();
          password.clear();
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        case ErrorFB<UserCredential>():
          Navigator.of(context).pop();
          AppDialog.showError(context, error: result.messageError);
      }
    }
  }

 */

}
