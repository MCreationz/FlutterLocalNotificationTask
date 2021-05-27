
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
mixin BaseClass {


  // Makes a screen to potrait only
  // implement in main class to make the whole app in potrait mode
  void portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // returns the width of the screen
  double getScreenWidth() {
    return Get.width;
  }

  //returns the height of the screen
  double getScreenHeight() {
    return Get.height;
  }

  // open next screen written in destination and keeps the previous screen in stack
  void pushToNextScreen(
      {@required BuildContext context, @required Widget destination}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  void popToPreviousScreen({@required BuildContext context}) {
    Navigator.pop(context);
  }

  void popToPreviousAndReturnData({@required BuildContext context}) {
    Navigator.pop(context, true);
  }

  //replaces the current screen with the destination and clears previous stack
  void pushAndReplace(
      {@required BuildContext context, @required Widget destination}) {
    //Navigator.of(context).pop();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => destination));
  }

  void pushToNextScreenLikeIOS(
      {@required BuildContext context, @required Widget destination}) {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => destination));
  }

  void pushToNextScreenWithAnimation(
      {@required BuildContext context, @required Widget destination}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        ),
        /*transitionDuration: Duration(milliseconds: 2000),*/
      ),
    );
  }

  void pushToNextScreenWithFadeAnimation(
      {@required BuildContext context, @required Widget destination,int duration =500}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: Duration(milliseconds: duration),
      ),
    );
  }

  void pushReplaceAndClearStack(
      {@required BuildContext context, @required Widget destination}) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => destination),
        (Route<dynamic> route) => false);
  }



  void fieldFocusChange(
      {BuildContext context, FocusNode currentFocus, FocusNode nextFocus}) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  String removeString({@required String value}) {
    String result = value.replaceAll("Exception: ", "");
    return result;
  }

  void removeFocusFromEditText({@required BuildContext context}) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }



  String getDeviceType() {
    if (Platform.isAndroid) {
      return "android";
    } else {
      return "ios";
    }
  }

/*  String getDateTime(int timestamp) {
    if (timestamp == null) return "";

    var date =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: false);
    String formattedTime = DateFormat('Hm').format(date);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(date);
    return (formattedDate + " " + formattedTime);
  }

  Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      return false;
    } else {
      return true;
    }
  }*/




  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      //Here you can setState a bool like internetAvailable = false;
      //or use call this before uploading data to firestore/storage depending upon the result, you can move on further.
      return false;
    }
  }

  String changeDateTimeFormat(String dateTime){
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(dateTime));
  }

}
