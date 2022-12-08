import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/screens/enable_location_screen.dart';
import 'package:foodizm_driver_app/screens/home_screen.dart';
import 'package:foodizm_driver_app/screens/login_screen.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    // final title = message.notification!.title;
    // final body = message.notification!.body;
    // showNotification(title: title, body: body);
  }
  print('Handling a background message ${message.messageId}');
  return Future<void>.value();
}

void showNotification({String? title, String? body}) {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('notification', 'Channel for notification',
      icon: 'app_icon', importance: Importance.max, priority: Priority.max, ticker: 'ticker', playSound: true);

  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: 'Custom_Sound');
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation1 = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  Timer? timer;

// For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("app is terminated and opened from notification:\n" +
          "title: " +
          initialMessage.notification!.title! +
          "\n" +
          "body: " +
          initialMessage.notification!.body!);
    }
  }

  registerNotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int? id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification notification = message!.notification!;
      AndroidNotification? android = message.notification?.android!;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'notification',
              'Channel for notification',
              icon: 'app_icon',
            ),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    checkForInitialMessage();

    //when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      print("app in background but not terminated and opened from notification:\n" +
          "title: " +
          message!.notification!.title! +
          "\n" +
          "body: " +
          message.notification!.body!);
    });

    registerNotification();
    super.initState();
    timer = new Timer(Duration(seconds: 3), () async {
      var status = await Permission.location.status;
      if (Utils().getUserId() != null) {
        if (status == PermissionStatus.granted) {
          Utils().getUserCurrentLocation('');
          Get.offAll(() => HomeScreen());
        } else {
          Get.offAll(() => EnableLocationScreen());
        }
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _animation1,
              child: Image.asset(
                "assets/images/logo.png",
                height: 250,
                width: 250,
              ),
            ),
            SvgPicture.asset(
              "assets/images/delivery.svg",
              height: 50,
              width: 50,
            ),
          ],
        ),
      ),
    );
  }
}
