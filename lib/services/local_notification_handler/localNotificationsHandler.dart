import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_task_manager/database/app_db.dart';
import 'package:flutter_task_manager/models/task_list_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService extends GetxController {
   FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin ;

  AppDatabase _appDatabase;

  //initilize
  @override
  void onInit() {
    _flutterLocalNotificationsPlugin=  FlutterLocalNotificationsPlugin();
    _appDatabase = AppDatabase();
    initLocalNotification();

    super.onInit();
  }

  Future<void> initLocalNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Instant Notifications
  Future instantNofitication() async {
    var android = AndroidNotificationDetails("id", "channel", "description");

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo instant notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  Future stylishNotification() async {
    var android = AndroidNotificationDetails("id", "channel", "description",
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Stylish notification", "Tap to do something", platform);
  }

  //Sheduled Notification

  Future scheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "Demo Sheduled notification",
        "Tap to do something",
        interval,
        platform);
  }

  Future scheduledZonedNotification() async {
   // var interval = RepeatInterval.everyMinute;
    print('SCHEDULED');
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('id', 'channel', 'description');
    //var platform = new NotificationDetails(android: android);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    for (int i = 0; i < _appDatabase.getSavedTasks().length; i++) {
      TaskListModel taskListModel =
          _appDatabase.getSavedTasks().get(i) as TaskListModel;
      if (!taskListModel.isCompleted) {
        tz.TZDateTime currentScheduled = _nextInstanceOfReminder(taskListModel.taskDateTime);
        print(currentScheduled);
        if(currentScheduled!=null) {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            Random().nextInt(100000) + i,
            'Task Name',
            taskListModel.taskName,
            currentScheduled,
            //_nextInstanceOfReminder(/*hour, minutes*/ taskListModel.taskDateTime),
            platformChannelSpecifics,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
            androidAllowWhileIdle: true,
          );
        }
      }
    }
  }

  tz.TZDateTime _nextInstanceOfReminder(
      /*int hour, int minutes*/
      String dateTime) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm").parse(dateTime);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, tempDate.year,
        tempDate.month, tempDate.day, tempDate.hour, tempDate.minute);
    if (scheduledDate.isBefore(now)) {
      return null;
    }
    return scheduledDate;
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
