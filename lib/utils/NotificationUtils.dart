import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kixat/model/PushNotificationModel.dart';
import 'package:kixat/utils/NotificationType.dart';

class NotificationUtils {

  NotificationDetails _platformChannelSpecifics;

  NotificationUtils() {
    _platformChannelSpecifics = NotificationDetails(
      android: getAndroidNotificationDetails(),
      iOS: getIosNotificationDetails(),
    );
  }

  getAndroidNotificationDetails() => AndroidNotificationDetails(
        '1123',
        'LocalNotificationChannel',
        'ChannelDescription',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );

  getIosNotificationDetails() => IOSNotificationDetails(
        presentAlert: false,
        presentBadge: false,
        presentSound: false,
      );

  NotificationDetails getNotificationSpecifics() => _platformChannelSpecifics;

  showFileDownloadNotification({String path}) async {
    // TODO open file on notification click
    var filename = "File";

    // For iOS request permission first.
    if(Platform.isIOS) {
      await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if(path!=null && path.isNotEmpty) {
      var tokens = path.split('/');
      if(tokens.isNotEmpty)
        filename = tokens.last;
    }

    final payload = jsonEncode(PushNotificationModel(
        body: path,
        itemId: '0',
        itemType: NotificationType.FILE_DOWNLOADED.toString(),
        title: 'Title'));

    FlutterLocalNotificationsPlugin().show(
      0, "$filename downloaded", "", _platformChannelSpecifics, payload: payload
    );
  }
}