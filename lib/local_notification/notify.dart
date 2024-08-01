// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:lazyui/lazyui.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void onTapBackground(NotificationResponse response) {
  logg('Received message from local: ${response.payload}');
}

class Notify {
  // create instance of class
  Notify._();
  static final Notify instance = Notify._();

  // method to initialized
  Future initialize() async {
    // make exception for web and linux, you can add others
    if (kIsWeb || Platform.isLinux) {
      return;
    }

    // do timezone initialization
    tz.initializeTimeZones();
    String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // config notification launch details
    final NotificationAppLaunchDetails? appLaunch = !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    // check if notification is launched
    if (appLaunch?.didNotificationLaunchApp ?? false) {
      logg('App is launched!');
    }

    // init for android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_launcher');

    // init for ios settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    // prepare both (android & ios)
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    // init local notification
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {},
      onDidReceiveBackgroundNotificationResponse: onTapBackground,
    );

    // after initialize all configuration, request notification permissions
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    logg('Local notification has been initialized!');
  }

  // method to show local notification
  static Future<void> show(String title, String body,
      {String? payload, String? channelId}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channelId ?? '', 'Your channel name',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }
}
