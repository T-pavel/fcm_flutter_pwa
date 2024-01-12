import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_fcm/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBqYAWHzo5qXoFRHCtFsCI1qH_00GaSXvc",
          appId: "1:98328623532:web:69bb560be609e2a2d32209",
          messagingSenderId: "98328623532",
          projectId: "test-9af84",
          storageBucket: "test-9af84.appspot.com",
          authDomain: "test-9af84.firebaseapp.com"));
  notificationService.listenNotifications();

  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.notificationService});
  final NotificationService notificationService;
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
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.notificationService,
  });
  final String title;

  final NotificationService notificationService;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _token = "No get token";

  void _setToken(String value) {
    setState(() {
      _token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _token));
                },
                child: SelectableText(
                  'User token $_token',
                )),
            ButtonBar(
              children: [
                TextButton(
                    onPressed: () async {
                      String value =
                          await widget.notificationService.getToken();
                      _setToken(value);
                    },
                    child: const Text('Получить токен')),
                TextButton(
                    onPressed: () async {
                      widget.notificationService
                          .sendPushMessage(_token, "Hello from main page");
                    },
                    child: const Text('Отправить уведомление')),
                TextButton(
                    onPressed: () async {
                      Timer(const Duration(seconds: 5), () async {
                        widget.notificationService
                            .sendPushMessage(_token, "Hello from main page");
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
