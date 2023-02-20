/*
import 'dart:html';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:hazir_hon_app/helpers/session_helper.dart';

import '../models/user.dart';
import '../providers/user_providers.dart';
import 'notificationservice.dart';
class NotificationHelper {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
   NotificationService notificationService = NotificationService();

  int currentIndex = 0;
  User? user;

  Future<void> getPageData() async {
    user = await getUserFromPrefs();
    setState(() {
      user = user;
    });
    await context.read<UserProvider>().setUser(user!);

    _firebaseMessaging.getToken().then((String? token) async {
      assert(token != null);
      setState(() {
        //_homeScreenText = "Push Messaging token: $token";
      });

      _firebaseMessaging.subscribeToTopic("all");
      Function fun = (tkn) async {
        var request = {
          "fcm_token": tkn,
        };
        var res = await MjApiService()
            .simplePostRequest(MJ_Apis.update_user + '/${user!.id}', request);

        print('payload: ${request}');
        print('res: ${res}');
      };
      if (await isLogin()) {
        fun(token);
      }
      print(token);
      // print(_homeScreenText);
    });
  }

  convertMessage(RemoteMessage message) {
    // message["data"] = message;
    try {
      var notification = {
        "title": message.data['aps']['title'],
        "body": message.data['aps']['body'],
        "data": message.data,
      };

      return notification;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showFlutterNotification(RemoteMessage fcmMessage) {
    debugPrint("show flutter notification");
    try {
      Map msg = fcmMessage.data;
      debugPrint("======+>Before Converted message");
      debugPrint(msg.toString());
      if (Platform.isIOS) {
        msg = convertMessage(fcmMessage);
      } else {
        msg = {
          "title": msg['notification']['title'],
          "body": msg['notification']['body'],
          "data": msg,
        };
      }
      debugPrint("======+>Converted message");
      debugPrint(msg.toString());
      NotificationService().showFloatingNotification(
          Random().nextInt(10000), msg['title'], msg['body'], 01);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
*/
