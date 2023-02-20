import 'dart:io';
import 'dart:math';

import 'package:citizen/providers/providers.dart';
import 'package:citizen/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'notification/notificationservice.dart';

Future<void> backgroundHandler(RemoteMessage fcmMessage) async {
  //when app in background receive notification on click this function will be trigger
  var msg = {};
  try {
    msg = {
      "title": fcmMessage.notification?.title,
      "body": fcmMessage.notification?.body,
      "data": fcmMessage.data,
    };
    NotificationService().showFloatingNotification(
        Random().nextInt(10000), msg['title'], msg['body'], 01);
  } catch (e) {
    debugPrint(e.toString());
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseMessaging.onBackgroundMessage(
      (message) => backgroundHandler(message));
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationService notificationService = NotificationService();

  convertMessage(RemoteMessage message) {
    // message["data"] = message;
    try {
      var notification = {
        "title": message.notification?.title,
        "body": message.notification?.body,
        "data": message.data,
      };

      return notification;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showFlutterNotification(RemoteMessage fcmMessage) {
    /////////
    debugPrint('showFlutterNotification: ${fcmMessage.notification?.body}');
    debugPrint('showFlutterNotification: ${fcmMessage.notification?.title}');
    //fcmMessage.notification?.body;
    //fcmMessage.notification?.title;
    ///////////
    debugPrint("show flutter notification");
    try {
      Map msg = fcmMessage.data;
      debugPrint("======+>Before Converted message");
      debugPrint('msg=+> $msg');
      if (Platform.isIOS) {
        msg = convertMessage(fcmMessage);
      } else {
        debugPrint('msg in main.dart: ${msg['title']}');
        msg = {
          "title": fcmMessage.notification?.title,
          "body": fcmMessage.notification?.body,
          "data": fcmMessage.data,
        };
      }
      debugPrint("======+>Converted message");
      debugPrint('msg+==>$msg');
      NotificationService().showFloatingNotification(
          Random().nextInt(10000), msg['title'], msg['body'], 01);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          debugPrint('initial msg: $message');
          debugPrint('init data: ${message.data}');
          debugPrint('init title: ${message.notification!.title}');
        }
      });
      FirebaseMessaging.onMessage.listen(showFlutterNotification);
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('A new onMessageOpenedApp event was published! $message');
        ////
        if (message.data != null) {
          message.data['title'];
          debugPrint('openapp title: ${message.data['title']}');
          debugPrint('message in=>: ${message}');
        }
        ///////
        // Navigator.pushNamed(
        //   context,
        //   '/message',
        //   arguments: MessageArguments(message, true),
        // );
      });
    });

    notificationService.isAndroidPermissionGranted();
    notificationService.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...providers],
      child: MaterialApp(
        localizationsDelegates: const [
          RefreshLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
