import 'package:citizen/constants/custom_route_transition.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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

nextScreen(context, widget) {
  Navigator.push(context, CustomRoute(builder: (context) => widget));
  //Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}
replaceScreen(context,widget){
  Navigator.pushReplacement(context, CustomRoute(builder: (context)=>widget));
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
      transitionDuration: Duration(milliseconds: 400),
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
              margin: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Center(
                            child: Image.asset(
                              icon,
                              width: 50,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${title}",
                            style: TextStyle(
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
                                  child: Text("Cancel"),
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

