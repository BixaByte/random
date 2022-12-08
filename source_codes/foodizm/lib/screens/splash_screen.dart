import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/user_model.dart';
import 'package:foodizm/screens/enable_location_screen.dart';
import 'package:foodizm/screens/home_screen.dart';
import 'package:foodizm/screens/introduction_screen.dart';
import 'package:foodizm/screens/profile_creation_screens/add_photo_screen.dart';
import 'package:foodizm/screens/profile_creation_screens/complete_profile_screen.dart';
import 'package:foodizm/screens/welcome_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

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
      icon: 'app_icon',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker',
      playSound: true);

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
  )
    ..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );
  Utils utils = new Utils();
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
      checkFirstSeen();
    });
  }

  Future checkFirstSeen() async {
    final box = Hive.box('credentials');
    bool _seen = (box.get('seen') ?? false);
    if (_seen) {
      if (utils.getUserId() != null) {
        checkUser(utils.getUserId());
      } else {
        Get.offAll(() => WelcomeScreen());
      }
    } else {
      await box.put('seen', true);
      Get.offAll(() => IntroductionScreen());
    }
  }

  checkUser(String uid) async {
    var status = await Permission.location.status;
    FirebaseDatabase.instance.reference().child('Users').child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        Common.userModel = UserModel.fromJson(Map.from(dataSnapshot.value));
        if (Common.userModel.profilePicture == 'default') {
          Get.offAll(() => AddPhotoScreen());
        } else if (Common.userModel.userName == 'default') {
          Get.offAll(() => CompleteProfileScreen());
        } else {
          if (status == PermissionStatus.granted) {
            utils.getUserCurrentLocation('');
            Get.offAll(() => HomeScreen());
          } else {
            Get.offAll(() => EnableLocationScreen());
          }
        }
      } else {
        Get.offAll(() => WelcomeScreen());
      }
    }).onError((error, stackTrace) {
      Get.offAll(() => WelcomeScreen());
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
              turns: _animation,
              child: Image.asset(
                "assets/images/logo.png",
                height: 250,
                width: 250,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
