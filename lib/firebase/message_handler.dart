import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_example/local_notification/notify.dart';
import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

class MessagesHandler {
  static onReceived(RemoteMessage message) async {
    try {
      String title = message.notification?.title ?? 'No Title!';
      String body = message.notification?.body ?? 'No message found!';

      Notify.show(title, body, payload: json.encode(message.data));
    } catch (e, s) {
      Utils.errorCatcher(e, s);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundReceived(RemoteMessage message) async {
    try {
      logg('Message received in background: ${message.data}');

    } catch (e, s) {
      Utils.errorCatcher(e, s);
    }
  }

  static onNotifOpened(RemoteMessage message) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // wait until your app is ready
        // you can also use timer to wait, then open specific screen
      } catch (e, s) {
        Utils.errorCatcher(e, s);
      }
    });
  }
}
