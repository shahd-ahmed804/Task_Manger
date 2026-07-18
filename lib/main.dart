
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/utils/show_welcome_notification.dart';
import 'features/auth/view/screens/login_screen.dart';
import 'features/auth/view/screens/register_screen.dart';
import 'features/auth/view_model/auth_cubit.dart';
import 'features/home/data/model/task_model.dart';
import 'features/home/view/screens/edit_screen.dart';
import 'features/home/view/screens/home_screen.dart';
import 'features/profile/profile_screen.dart';
import 'firebase_options.dart';
import 'main_layout.dart';
import 'onboarding_screen.dart';
import 'package:taskey_app/features/home/view_model/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeNotifications();
  final initialRoute = await getInitialRoute();
  runApp(ToDoApp(initialRoute:initialRoute));
}
Future<String> getInitialRoute()async{
  final prefs = await SharedPreferences.getInstance();
  final onBoardingDone = prefs.getBool('onBoardingDone')??false;
  if(!onBoardingDone){
    return OnboardingScreen.routeName;
  }
  if(FirebaseAuth.instance.currentUser !=null){
    return MainLayout.routeName;
  }
  return LoginScreen.routeName;
}

class ToDoApp extends StatelessWidget {
  final String initialRoute;
  const ToDoApp({
    super.key,
    required this.initialRoute,
  });
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthCubit(),
          ),
          BlocProvider(
            create: (_) => HomeCubit(),
          ),
        ],
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
