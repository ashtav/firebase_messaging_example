import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging_example/firebase/firebase_messaging.dart';
import 'package:firebase_messaging_example/local_notification/notify.dart';
import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

import 'screens/home_view.dart';

void main() async {
  LazyUi.init();

  // initialize firebase
  await Firebase.initializeApp();

  // initialize firebase messaging to listen messages
  FBMessaging.instance.initMessaging();

  // initialize local notification
  Notify.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FM Example',
      theme: LzTheme.light,
      home: const HomeView(),
    );
  }
}
