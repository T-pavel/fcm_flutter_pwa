import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_fcm/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBqYAWHzo5qXoFRHCtFsCI1qH_00GaSXvc",
          appId: "1:98328623532:web:69bb560be609e2a2d32209",
          messagingSenderId: "98328623532",
          projectId: "test-9af84",
          storageBucket: "test-9af84.appspot.com",
          authDomain: "test-9af84.firebaseapp.com"));
  final notificationService = NotificationService();
  notificationService.listenNotifications();
  final String token = await notificationService.getToken();

  runApp(MyApp(notificationService: notificationService, token: token));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key, required this.notificationService, required this.token});
  final NotificationService notificationService;
  final String token;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
          title: 'Flutter demo FCM with PWA',
          notificationService: notificationService,
          token: token),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage(
      {super.key,
      required this.title,
      required this.notificationService,
      required this.token});
  final String title;
  final String token;

  final NotificationService notificationService;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: token));
                },
                child: SelectableText(
                  'User token $token',
                )),
            ButtonBar(
              children: [
                TextButton(
                    onPressed: () async {
                      notificationService.sendPushMessage(
                          token, "Hello from main page");
                    },
                    child: const Text('Отправить уведомление')),
                TextButton(
                    onPressed: () async {
                      Timer(const Duration(seconds: 5), () async {
                        notificationService.sendPushMessage(
                            await notificationService.getToken(),
                            "Hello from main page");
                      });
                    },
                    child: const Text('Отправить уведомление c задержкой')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
