import 'package:app/common.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  int notificationCounter = 0;

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> show(Warning warn) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('1', 'Warnings',
            channelDescription: 'Warning Channel',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority);

    await flutterLocalNotificationsPlugin.show(
      notificationCounter++,
      warn.title,
      warn.body,
      const NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }
}
