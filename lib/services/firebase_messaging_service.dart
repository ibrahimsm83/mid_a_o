import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mao/utils/app_strings.dart';

class FirebaseMessagingService {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  IOSInitializationSettings? _initializationSettingsIOS;
  AndroidInitializationSettings? _initializationSettingsAndroid;
  AndroidNotificationDetails? _androidLocalNotificationDetails;
  AndroidNotificationChannel? androidNotificationchannel;
  static FirebaseMessagingService? _messagingService;
  NotificationDetails? _androidNotificationDetails;
  InitializationSettings? _initializationSettings;
  NotificationAppLaunchDetails? _notificationAppLaunchDetails;
  bool? _didNotificationLaunchApp;
  StreamSubscription? _deepLinkSubscription;

  static FirebaseMessaging? _firebaseMessaging;

  FirebaseMessagingService._createInstance();


  factory FirebaseMessagingService() {
    // factory with constructor, return some value
    if (_messagingService == null) {
      _messagingService = FirebaseMessagingService
          ._createInstance(); // This is executed only once, singleton object

      _firebaseMessaging = _getMessagingService();
    }
    return _messagingService!;
  }

  static FirebaseMessaging _getMessagingService() {
    return _firebaseMessaging ??= FirebaseMessaging.instance;
  }

  Future<String?> getToken() {
    return _firebaseMessaging!.getToken();
  }


  Future initializeNotificationSettings() async
  {
    NotificationSettings? settings = await _firebaseMessaging
        ?.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else
    if (settings?.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    androidNotificationchannel = AndroidNotificationChannel(
      AppStrings.NOTIFICATION_ID, // id
      AppStrings.NOTIFICATION_PUSH_TITLE, // title
      description: AppStrings.NOTIFICATION_PUSH_DESCRIPTION,
      // description
      importance: Importance.max,
    );
    //
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationchannel!);


    //check if data comes from any link(app yaha sa start hogi)
    await terminateTapNotification();


    if (Platform.isIOS) {
      //configure local notification for ios
      await _initializeIosLocalNotificationSettings();
    }
    else {
      //configure local notification for android
      await _initializeAndroidLocalNotificationSettings();
    }
  }


  Future<void> _initializeIosLocalNotificationSettings() async
  {
    _initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false
    );
    _initializationSettings = InitializationSettings(
        iOS: _initializationSettingsIOS
    );


    await _flutterLocalNotificationsPlugin.initialize(
        _initializationSettings!,
        onSelectNotification: onTapLocalNotification);
  }


  Future<void> _initializeAndroidLocalNotificationSettings() async
  {
    _initializationSettingsAndroid =
        AndroidInitializationSettings('app_notification_icon');
    _initializationSettings = InitializationSettings(
      android: _initializationSettingsAndroid,
    );
    _androidLocalNotificationDetails =
        AndroidNotificationDetails(
            AppStrings.LOCAL_NOTIFICATION_ID,
            AppStrings.LOCAL_NOTIFICATION_TITLE,
            channelDescription: AppStrings.LOCAL_NOTIFICATION_DESCRIPTION,
            importance: Importance.max,
            priority: Priority.high);
    _androidNotificationDetails =
        NotificationDetails(android: _androidLocalNotificationDetails);

    await _flutterLocalNotificationsPlugin.initialize(
        _initializationSettings!,
        onSelectNotification: onTapLocalNotification);
  }


  




  Future<void> _backgroundTapLocalNotification() async
  {
await terminateTapNotification();
  }


  //This will execute when the app is open and in foreground
  void foregroundNotification() {
    //To registered firebase messaging listener only once
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      log("Message:${message?.data}");
      // log("Notification:${message?.notification?.title}");

      //log("Second:${DateTime.now().hour + DateTime.now().minute + DateTime.now().second}");
      try {
        _showLocalNotification(localNotificationId: DateTime
            .now()
            .hour + DateTime
            .now()
            .minute + DateTime
            .now()
            .second, notificationData: message?.data);
      } catch (error) {
        log("error");
      }
    });
  }


  //This will excute when the app is in background but not killed and tap on that notification
  void backgroundTapNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      try {
        
       
        //log("Background Message:${message?.data}");

        // if (SharedPreference().getUser() != null) {
        //   if (message != null && message.data != null) {
        //     // log("Temrinated Message Data:${_terminatedMessage.data}");
        //     _notificationNavigationClass.notificationMethod(
        //         context: StaticData.navigatorKey.currentContext!,
        //         notificationData: message.data,
        //         pushNotificationType: AppStrings.BACKGROUND_NOTIFICATION
        //     );
        //   }
        //   else {
        //     _notificationNavigationClass.checkUserSessionMethod(
        //         context: StaticData.navigatorKey.currentContext!);
        //   }
        // } else {
        //   _notificationNavigationClass.checkUserSessionMethod(
        //       context: StaticData.navigatorKey.currentContext!);
        // }
      } catch (error) {
        log("error");
      }
    });
  }

  //This will work when the app is killed and notification comes and tap on that notification
  Future<void> terminateTapNotification() async
  {
    RemoteMessage? _terminatedMessage = await _firebaseMessaging
        ?.getInitialMessage();
    // if (SharedPreference().getUser() != null) {
    //     if (_terminatedMessage != null && _terminatedMessage.data != null) {
    //       // log("Temrinated Message Data:${_terminatedMessage.data}");
    //       _notificationNavigationClass.notificationMethod(
    //           context: StaticData.navigatorKey.currentContext!,
    //           notificationData: _terminatedMessage.data,
    //           pushNotificationType: AppStrings.KILLED_NOTIFICATION
    //       );
    //     }
    //     else {
    //       _notificationNavigationClass.checkUserSessionMethod(
    //           context: StaticData.navigatorKey.currentContext!);
    //     }
    //   }
      
    // } else {
    //   _notificationNavigationClass.checkUserSessionMethod(
    //       context: StaticData.navigatorKey.currentContext!);
    // }
  }


  void _showLocalNotification(
      {int? localNotificationId, Map<String, dynamic>? notificationData}) async
  {
    if (notificationData != null) {
      log("Notification Data:${notificationData}");
      // log("Notification Data:${notificationData["notification_type"]}");
      // log("Other Id:${notificationData["other_id"] is int}");

      //agar same friend ki chat ha to phir local notification nhi aigi

        await _flutterLocalNotificationsPlugin.show(
            localNotificationId ?? 0, notificationData["title"],
            notificationData["body"],
            _androidNotificationDetails,
            payload: jsonEncode(notificationData));
      
    }
  }


  //on tap local notification
  void onTapLocalNotification(String? payload) async {
    Map<String, dynamic> _notificationData = {};
    if (payload != null) {
      _notificationData = jsonDecode(payload);
      // log('notification payloads: $_notificationData');
      // AppDialogs.showToast(message: "Notification"+_notificationData.toString());
      //_appNotification.notificationMethod(context: StaticData.navigatorKey.currentContext!);

    //   if (SharedPreference().getUser() != null) {
    //     if (_notificationData != null) {
    //       log("Local Message Data:${payload}");


    //       _notificationNavigationClass.notificationMethod(
    //           context: StaticData.navigatorKey.currentContext!,
    //           notificationData: _notificationData,
    //           pushNotificationType: AppStrings.FOREGROUND_NOTIFICATION
    //       );
    //     }
    //     else {
    //       _notificationNavigationClass.checkUserSessionMethod(
    //           context: StaticData.navigatorKey.currentContext!);
    //     }
    //   } else {
    //     _notificationNavigationClass.checkUserSessionMethod(
    //         context: StaticData.navigatorKey.currentContext!);
    //   }
    // } else {
    //   _notificationNavigationClass.checkUserSessionMethod(
    //       context: StaticData.navigatorKey.currentContext!);
    //}
  }
  }





}