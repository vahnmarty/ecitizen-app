import 'dart:convert';
import 'package:citizen/api/api.dart';
import 'package:citizen/config/config.dart';
import 'package:citizen/models/directory_model.dart';
import 'package:citizen/providers/news_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:telephony/telephony.dart';
import 'package:citizen/constants/custom_route_transition.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/hotlines_model.dart';
import '../models/news_model.dart';
import '../screens/web_view_screen.dart';

const cardHeadingStyle =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white);

getFormattedDate(String str) {
  //var str = "2023-01-20T15:20:32.000000Z";
  var newStr = str.substring(0, 10) + ' ' + str.substring(11, 23);
  DateTime dt = DateTime.parse(newStr);
  return DateFormat("MMMM d yyyy").format(dt);
  //print(DateFormat("EEE, d MMMM d yyyy HH:mm:ss").format(dt));
}

getFormattedDateTime(String str) {
  //var str = "2023-01-20T15:20:32.000000Z";
  var newStr = str.substring(0, 10) + ' ' + str.substring(11, 23);
  DateTime dt = DateTime.parse(newStr);

  return DateFormat("MMMM d yyyy hh:mm:ss a").format(dt);
  return DateFormat("EEE, d MMMM d yyyy HH:mm:ss").format(dt);
}

getCurrentTime() {
  var time = DateFormat('hh:mm a').format(DateTime.now());
  return time;
}

getTodayDate() {
  DateTime dateTime = DateTime.now();
  var date = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('MMMM dd yyyy');
  var outputDate = outputFormat.format(inputDate);
  //debugPrint('output: $outputDate');
  return outputDate;
}

getWidth(context) {
  return MediaQuery.of(context).size.width;
}

getHeight(context) {
  return MediaQuery.of(context).size.height;
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> openMail(context, String receiver, String subject) async {
  var apps = await OpenMailApp.getMailApps();

  if (apps.isEmpty) {
    showNoMailAppsDialog(context);
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return MailAppPickerDialog(
          mailApps: apps,
          emailContent: EmailContent(
            to: [
              receiver,
            ],
            subject: subject,
          ),
        );
      },
    );
  }
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Open Mail App"),
        content: const Text("No mail apps installed"),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

nextScreen(context, widget) {
  Navigator.push(context, CustomRoute(builder: (context) => widget));
  //Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

replaceScreen(context, widget) {
  Navigator.pushReplacement(context, CustomRoute(builder: (context) => widget));
}

class Constraints {
  static String infoIcon = 'assets/icons/alert/info.png';
  static String successIcon = 'assets/icons/alert/success.png';
  static String warningIcon = 'assets/icons/alert/warning.png';
  static String errorIcon = 'assets/icons/alert/error.png';
}

enum AlertType { INFO, WARNING, ERROR, SUCCESS }

showAlertDialog(context, title, message,
    {type = AlertType.INFO,
    okButtonText = 'Ok',
    onPress = null,
    showCancelButton = true,
    dismissible = true}) {
  String icon;

  switch (type) {
    case AlertType.INFO:
      icon = Constraints.infoIcon;
      break;
    case AlertType.SUCCESS:
      icon = Constraints.successIcon;
      break;
    case AlertType.WARNING:
      icon = Constraints.warningIcon;
      break;
    case AlertType.ERROR:
      icon = Constraints.errorIcon;
      break;
    default:
      icon = Constraints.infoIcon;
  }
  showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (_, anim, __, child) {
        var begin = 0.5;
        var end = 1.0;
        var curve = Curves.bounceOut;
        if (anim.status == AnimationStatus.reverse) {
          curve = Curves.fastLinearToSlowEaseIn;
        }
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return ScaleTransition(
          scale: anim.drive(tween),
          child: child,
        );
      },
      pageBuilder: (BuildContext alertContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(dismissible);
          },
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Center(
                            child: Image.asset(
                              icon,
                              width: 50,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "$title",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Text("$message"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (showCancelButton)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(alertContext).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                              if (onPress != null)
                                TextButton(
                                  onPressed: onPress,
                                  child: Text("$okButtonText"),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

internetConnectivity() async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  } catch (e) {
    debugPrint('connectivity error=> $e');
    return false;
  }
}

Future<void> shareToFacebook(String link) async {
  final facebookShareLink =
      'https://www.facebook.com/sharer/sharer.php?u=$link';
  if (await canLaunch(facebookShareLink)) {
    await launch(facebookShareLink);
  } else {
    throw 'Could not launch $facebookShareLink';
  }
}

Future<void> shareToTwitter(String link) async {
  final String twitterLink =
      'https://twitter.com/intent/tweet?text=Check%20out%20this%20news%20post:%20$link';

  if (await canLaunch(twitterLink)) {
    await launch(twitterLink);
  } else {
    throw 'Could not launch $twitterLink';
  }
}

enum SMSSTATUS { SENT, NOTSENT, NOTCAPABLE, NOTGRANTED }

final SmsSendStatusListener listener = (SendStatus status) {
  if (status == SendStatus.SENT) {
    return SMSSTATUS.SENT;
  }
  return SMSSTATUS.NOTSENT;
};
openWebView(BuildContext context,String name){
  nextScreen(context, WebViewScreen(pageName: name));
}
sendSms(String message) async {
  debugPrint('in sent');
  final Telephony telephony = Telephony.instance;
  try{
    bool? permissionGranted = await telephony.requestSmsPermissions;
    debugPrint('sms persmi: $permissionGranted');
    if (permissionGranted!) {
      bool? capable = await telephony.isSmsCapable;
      if (capable!) {

        debugPrint('sms capable: $capable');
        telephony.sendSms(
            to: '${Config.SMS_NUMBER}',
            message: message,
            statusListener: (SendStatus status) {
              if (status == SendStatus.SENT) {
                return SMSSTATUS.SENT;
              }

            });
      } else {
        return SMSSTATUS.NOTCAPABLE;
      }
    } else {
      return SMSSTATUS.NOTGRANTED;
    }
  }catch(e){
    debugPrint('error sms permission=>$e');
    return SMSSTATUS.NOTGRANTED;
  }

}

saveNewsJson(dynamic news) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('news', jsonEncode(news));
}

getNewsFromJson() async {
  List<News> list = [];
  final prefs = await SharedPreferences.getInstance();
  try {
    final response = await jsonDecode(prefs.getString('news')!);
    if (response.length != 0 && response != '' && response != null) {
      for (var i = 0; i < response.length; i++) {
        list.add(News.fromJson(response[i]));
      }
      return list;
    }
    return null;
  } catch (e) {
    return null;
  }
}

saveLguOfficesDirectories(dynamic directories) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('lguDirectories', jsonEncode(directories));
}

getLguOfficesDirectories() async {
  List<DirectoryModel> list = [];
  final prefs = await SharedPreferences.getInstance();
  try {
    final response = await jsonDecode(prefs.getString('lguDirectories')!);
    if (response.length != 0 && response != '' && response != null) {
      for (var i = 0; i < response.length; i++) {
        list.add(DirectoryModel.fromJson(response[i]));
      }
      return list;
    }
    return null;
  } catch (e) {
    return null;
  }
}

saveEmergencyHotlines(dynamic news) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('saveEmergency', jsonEncode(news));
}

getEmergencyHotlines() async {
  List<HotlinesModel> list = [];
  final prefs = await SharedPreferences.getInstance();
  try {
    final response = await jsonDecode(prefs.getString('saveEmergency')!);
    if (response.length != 0 && response != '' && response != null) {
      for (var i = 0; i < response.length; i++) {
        list.add(HotlinesModel.fromJson(response[i]));
      }
      return list;
    }
    return null;
  } catch (e) {
    return null;
  }
}
