import 'dart:convert';
import 'package:syslab_admin/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:syslab_admin/service/notification/local_notification.dart';

class FirebaseNotification {
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    // log('Handling a background message ${message.messageId}');
  }

  static handleNotifications(context) async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        badge: true,
        alert: true,
        sound: true); //presentation options for Apple notifications when received in the foreground.

    FirebaseMessaging.onMessage.listen((message) async {
      // log('Got a message whilst in the FOREGROUND!');

      return;
    }).onData((data) {
      LocalNotification.showNotification(
          data.data["title"], data.data["body"]);
      // log('Got a DATA message whilst in the FOREGROUND!');

      // log('data from  onMessage stream: ${data.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      // log('NOTIFICATION MESSAGE TAPPED');
      return;
    }).onData((data) {
      // log('NOTIFICATION MESSAGE TAPPED');
      // log('data from onMessageOpenedApp stream: ${data.data}');
      Navigator.pushNamed(context, "/NotificationListPage");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then(
        (value) => value != null ? _firebaseMessagingBackgroundHandler : false);
    return;
  }

  static Future<void> sendPushMessage(
      String token, String title, String body) async {
    String serverKey = firebaseServerKey;

    String _token = token;
    // if (_token == null) {
    //   log('Unable to send FCM message, no token exists.');
    //   return;
    // }

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey'
        },
        body: constructFCMPayload(_token, title, body),
      );
      // log('FCM request for device sent!');
    } catch (e) {
      // log(e);
    }
  }

  static String constructFCMPayload(String token, String title, String body) {
    return jsonEncode({
      "to": token,
      "notification": {
        "sound": "default",
        "body": body,
        "title": title,
        "content_available": true,
        "priority": "high"
      },
      "data": {
        "sound": "default",
        "body": body,
        "title": title,
        "content_available": true,
        "priority": "high"
      }
    });
  }
}
