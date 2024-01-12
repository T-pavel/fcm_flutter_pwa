import 'dart:convert';
import 'dart:html' as dartHtml;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  void _showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    Fluttertoast.showToast(msg: notification?.body ?? "Ошибка");
  }

  Future<void> listenNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessage.listen(_showFlutterNotification);
  }

  Future<String> getToken() async {
    return await FirebaseMessaging.instance.getToken() ?? 'Is not token';
  }

  String _constructFCMPayload(String? token, String body) {
    return jsonEncode({
      'to': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging',
      },
      'notification': {
        'title': 'Title notification - FCM from my flutter app',
        'body': body,
      },
    });
  }

  Future<void> sendPushMessage(String token, String body) async {
    try {
      const String serverKey =
          "AAAAFuTXuaw:APA91bHjrcfl-jTaKSxK_nRRkYN-QZ81xhHeESNtLp_86vxMKJ-WAdvavwhi9ugEuhvJIVCUQEuXgZgEc0fnzx71vXqqz4UpPzJmQRZtUJuDU9or7_joSaDHoOpV746Dj_HEfJOyUggH";
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey'
        },
        body: _constructFCMPayload(token, body),
      );
      debugPrint('FCM request for device sent!');
    } catch (e) {
      debugPrint('------ $e ------');
    }
  }
}
