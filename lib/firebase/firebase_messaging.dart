import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lazyui/lazyui.dart';

import 'message_handler.dart';

class FBMessaging {
  // create instance of class
  FBMessaging._();
  static final FBMessaging instance = FBMessaging._();

  // create initialize method
  void initMessaging() async {
    logg('Firebase initialized is running...');

    try {
      // first, request notif permissions
      final permission = await FirebaseMessaging.instance.requestPermission();

      // check permission status
      if (permission.authorizationStatus == AuthorizationStatus.authorized) {
        final message = await FirebaseMessaging.instance.getInitialMessage();
        logg('Initial message: $message');

        // get token (for testing)
        final token = await FirebaseMessaging.instance.getToken();
        logg('Token: $token');

        // listen to message
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          logg('Message received: ${message.data}');
          MessagesHandler.onReceived(message);
        });

        // listen to message in background
        // onBackgroundMessage should be used like this (Asynchronous Function Reference)
        FirebaseMessaging.onBackgroundMessage(MessagesHandler.onBackgroundReceived);

        // listen to notification event
        FirebaseMessaging.onMessageOpenedApp
            .listen((RemoteMessage message) async {
          logg('Notification is opened: ${message.data}');
          MessagesHandler.onNotifOpened(message);
        });

        return;
      }

      // permission is denied
      logg('Notification permissions is denied!');
    } catch (e, s) {
      Utils.errorCatcher(e, s);
    }
  }

  // subscribe to specific topic / channel
  static Future subscribe(List<String> channel) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    await Future.forEach(channel, (value) async {
      await firebaseMessaging.subscribeToTopic(value);
    });
  }

  // un-subscribe to specific topic / channel
  static Future unSubscribe(List<String> channel) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    await Future.forEach(channel, (value) async {
      await firebaseMessaging.unsubscribeFromTopic(value);
    });
  }
}
