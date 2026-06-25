import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskey_app/auth/screens/login_screen.dart';
import 'package:taskey_app/auth/screens/register_screen.dart';
import 'package:taskey_app/home/data/model/task_model.dart';
import 'package:taskey_app/home/screen/edit_screen.dart';
import 'package:taskey_app/home/screen/home_screen.dart';
import 'package:taskey_app/core/utils/show_welcome_notification.dart';
import 'package:taskey_app/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';


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
