import 'package:firebase_messaging_example/firebase/firebase_messaging.dart';
import 'package:firebase_messaging_example/local_notification/notify.dart';
import 'package:flutter/material.dart';
import 'package:lazyui/lazyui.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    String topic = 'example';

    void subscribe() async {
      await FBMessaging.subscribe([topic]);
      logg('topic: $topic has been subscribed!');
    }

    void unsubscribe() async {
      await FBMessaging.subscribe([topic]);
      logg('topic: $topic has been un-subscribed!');
    }

    return Scaffold(
      backgroundColor: '212121'.hex,
      body: Container(
        padding: Ei.all(25),
        child: Center(
          child: Column(
            mainAxisAlignment: Maa.center,
            children: [
              Text('Firebase Messaging',
                  style: Gfont.fs18.bold.white, textAlign: Ta.center),
              Text('Testing firebase messaging with channel name is: $topic',
                  style: Gfont.white, textAlign: Ta.center),
              25.height,
              LzButton(text: 'Subscribe', onTap: (_) => subscribe()),
              LzButton(text: 'Un-Subscribe', onTap: (_) => unsubscribe()),
              15.height,
              LzButton(
                  text: 'Test Local Notification',
                  onTap: (_) => Notify.show('Local Notification',
                      'Hello dude! This is an example of notification from your local device!')),
            ],
          ).gap(5),
        ),
      ),
    );
  }
}
