import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:softify/model/PushNotificationModel.dart';
import 'package:softify/repository/SettingsRepository.dart';
import 'package:softify/service/GlobalService.dart';
import 'package:softify/utils/GetBy.dart';
import 'package:softify/utils/NotificationUtils.dart';
import 'package:softify/utils/NotificationType.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:softify/utils/utility.dart';
import 'package:softify/views/pages/account/order/order_details_screen.dart';
import 'package:softify/views/pages/account/registration_sceen.dart';
import 'package:softify/views/pages/more/topic_screen.dart';
import 'package:softify/views/pages/product-list/product_list_screen.dart';
import 'package:softify/views/pages/product/product_details_screen.dart';
import 'package:open_file/open_file.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("FCM background message: ${message?.data?.toString()}");
  return;
}

class FcmHandler extends StatefulWidget {
  final Widget child;
  const FcmHandler({Key key, @required this.child}) : super(key: key);

  @override
  _FcmHandlerState createState() => _FcmHandlerState();
}

class _FcmHandlerState extends State<FcmHandler> {
  static bool initialized = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const IOSNotificationDetails iosLiquidChannel = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: "default");

  Future selectNotification(String payload) async {
    if (payload != null) {
      log('notification payload android: $payload');
      setupNotificationClickAction(payload);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    if (payload != null) {
      log('notification payload android: $payload');
      setupNotificationClickAction(payload);
    }
  }

  @override
  void initState() {
    super.initState();

    if (!initialized) initializeFcm();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> initializeFcm() async {
    if (!initialized) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification,
      );

      // initialize Firebase
      await Firebase.initializeApp();
      log("Requesting FCM token...");

      // turn off crash reporting for debug mode
      if (kDebugMode) {
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false);
      }

      // Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      try {
        String token = await FirebaseMessaging.instance.getToken();
        log("FCM token: $token");

        GlobalService().setFcmToken(token);

        initialized = true;

        // post token to server
        var response = await SettingsRepository().postFcmToken(token);
        log("FCM Token sent to server: ${response.toJson().toString()}");
      } catch (e) {
        log("FCM token error: $e");
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('FCM foreground message: ${message.data}\n notification - ${message.notification ?? ''}');

      if (Platform.isAndroid) {
        flutterLocalNotificationsPlugin.show(
          0,
          message.data['title'],
          message.data['body'],
          NotificationUtils().getNotificationSpecifics(),
          payload: json.encode(message.data),
        );
      } else if (Platform.isIOS) {
        flutterLocalNotificationsPlugin.show(
          0,
          message.notification.title,
          message.notification.body,
          NotificationDetails(iOS: iosLiquidChannel),
          payload: json.encode(message.data),
        );
      }
    });

    FirebaseMessaging?.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        setupNotificationClickAction(json.encode(message.data));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      setupNotificationClickAction(json.encode(message.data));
    });
  }

  void setupNotificationClickAction(String payload) {
    // handle firebase and local notification clicks here

    final data = pushNotificationModelFromJson(payload);
    final itemId = num.tryParse(data.itemId) ?? 0;

    switch (int.tryParse(data.itemType) ?? 0) {
      case NotificationType.PRODUCT:
        Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
            arguments: ProductDetailsScreenArguments(
              id: itemId,
              name: '',
            ));
        break;

      case NotificationType.CATEGORY:
        Navigator.of(context).pushNamed(ProductListScreen.routeName,
            arguments: ProductListScreenArguments(
                id: itemId, name: '', type: GetBy.CATEGORY));
        break;

      case NotificationType.MANUFACTURER:
        Navigator.of(context).pushNamed(ProductListScreen.routeName,
            arguments: ProductListScreenArguments(
                id: itemId, name: '', type: GetBy.MANUFACTURER));
        break;

      case NotificationType.VENDOR:
        Navigator.of(context).pushNamed(ProductListScreen.routeName,
            arguments: ProductListScreenArguments(
                id: itemId, name: '', type: GetBy.VENDOR));
        break;

      case NotificationType.ORDER:
        Navigator.of(context).pushNamed(OrderDetailsScreen.routeName,
            arguments: OrderDetailsScreenArguments(orderId: itemId));
        break;

      case NotificationType.ACCOUNT:
        Navigator.of(context).pushNamed(RegistrationScreen.routeName,
            arguments: RegistrationScreenArguments(getCustomerInfo: true));
        break;

      case NotificationType.TOPIC:
        Navigator.of(context).pushNamed(TopicScreen.routeName,
            arguments: TopicScreenArguments(topicId: itemId));
        break;

      case NotificationType.FILE_DOWNLOADED:
        openDownloadedFile(data.body);
        break;
    }
  }

  void openDownloadedFile(String path) async {
    final _result = await OpenFile.open(path);
    // print('${_result.message} >> ${_result.type.index}');

    if (_result.type.index != 0) {
      showSnackBar(context, _result.message, true);
    }
  }
}
