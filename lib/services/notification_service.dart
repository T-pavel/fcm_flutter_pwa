import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationService {
  void _showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    Fluttertoast.showToast(msg: notification?.body ?? "Ошибка");
  }

  Future<void> listenNotifications() async {
    FirebaseMessaging.onMessage.listen(_showFlutterNotification);
  }

  Future<String> getToken() async {
    return await FirebaseMessaging.instance.getToken() ?? 'Is not token';
  }
}
