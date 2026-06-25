/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskey_app/home/data/model/task_model.dart';
import 'package:taskey_app/core/utils/show_welcome_notification.dart';
import 'package:taskey_app/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth/view/login_screen.dart';
import 'auth/view/register_screen.dart';
import 'firebase_options.dart';
import 'home/view/edit_screen.dart';
import 'home/view/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser?.uid == null
          ? OnboardingScreen.routeName
          : HomeScreen.routeName,
      routes: {
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        EditScreen.routeName: (context) {
          final task = ModalRoute.of(context)?.settings.arguments as TaskModel;

          return EditScreen(task: task);
        },
      },
    );
  }
}


void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');

  const DarwinInitializationSettings initializationSettingsDarwin = 
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

 */


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskey_app/profile/profile_screen.dart';
import 'auth/view/login_screen.dart';
import 'auth/view/register_screen.dart';
import 'auth/view_model/auth_cubit.dart';
import 'core/utils/show_welcome_notification.dart';
import 'firebase_options.dart';
import 'home/data/model/task_model.dart';
import 'home/view/edit_screen.dart';
import 'home/view/home_screen.dart';
import 'main_layout.dart';
import 'onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeNotifications();

  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? OnboardingScreen.routeName
            : MainLayout.routeName,
        routes: {
          OnboardingScreen.routeName: (_) => const OnboardingScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          ProfileScreen.routeName:(_) => const ProfileScreen(),
          MainLayout.routeName:(_) => const MainLayout(),

      EditScreen.routeName: (context) {
            final task =
            ModalRoute.of(context)!.settings.arguments as TaskModel;

            return EditScreen(task: task);
          },
        },
      ),
    );
  }
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('launch_background');

  const DarwinInitializationSettings initializationSettingsDarwin =
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}