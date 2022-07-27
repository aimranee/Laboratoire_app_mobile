import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocalNotification{

  static var buildContext;

  static initializeFlutterNotification(context) {
    buildContext=context;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    const AndroidInitializationSettings("app_icon");
    var initSetttings = InitializationSettings(
        android:  initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }
  static Future onSelectNotification(String payload)async {
    // log("===================Flutter local notification payload $payload");
    Navigator.pushNamed(buildContext,"/NotificationListPage");

  }
  static Future<void> showNotification(String title,String body) async {
    // log("===================show notification==============");
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 
        // 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }
}