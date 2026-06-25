import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showWelcomeNotification({
  required String userName,
  required int totalTasksCount,
  required int pendingTasksCount,
}) async {
  String title;
  String body;


  final completedTasksCount = totalTasksCount - pendingTasksCount;

  if (totalTasksCount == 0) {
    title = 'Hi $userName 👋';
    body = 'Don,t hava any taskss today, lets add some ';
  } else if (pendingTasksCount == 0) {
    title = 'Hi $userName 🏆';
    body = 'Congratulations!👋 You finished all your tasks 🎉';
  } else {
    title = 'Hi $userName 👋';
    body =
        'Remainder 🔔 you complete $completedTasksCount task and remaining $pendingTasksCount task 💪';
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'taskey_welcome_channel',
    'Welcome Alerts',
    channelDescription: 'Alerts when the user logs in.',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'launch_background',
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    100,
    title,
    body,
    platformDetails,
    payload: 'tasks_list',
  );
}
