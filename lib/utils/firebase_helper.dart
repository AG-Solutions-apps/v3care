import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static FirebaseHelper firebaseHelper = FirebaseHelper._();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String> getFirebaseToken() async {
    try {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String token = await firebaseMessaging.getToken() ?? '';
      await firebaseMessaging
          .subscribeToTopic(DateTime.now().microsecondsSinceEpoch.toString());
      return token;
    } catch (error) {
      return "";
    }
  }

  Future<void> initializeFirebaseMessaging() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    // var token = await firebaseMessaging.getToken();
    // print("=== TOKEN === $token");
    initializeNotification();

    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
            alert: true,
            sound: true,
            badge: true,
            announcement: true,
            carPlay: true,
            criticalAlert: true,
            provisional: true);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }

    FirebaseMessaging.onMessage.listen((msg) async {
      if (msg.notification != null) {
        var body = msg.notification!.body.toString();
        var title = msg.notification!.title.toString();
        await showFirebaseNotification(title: title, body: body);
      }
    });
  }

  //Initialize Notification
  void initializeNotification() {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('ic_launcher');

    DarwinInitializationSettings iOSInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Show Simple Notification
  Future<void> showFirebaseNotification(
      {required String title, required String body}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "1",
      "Android",
      importance: Importance.high,
      priority: Priority.max,
      styleInformation: BigTextStyleInformation(''),
    );

    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails(
      subtitle: "IOS",
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      notificationDetails,
    );
  }
}
