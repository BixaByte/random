import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/restaurant_details_model.dart';
import 'package:foodizm_admin_app/screens/home_screen.dart';
import 'package:foodizm_admin_app/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

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
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  Timer? timer;

  var databaseReference = FirebaseDatabase.instance.reference();

  final box = Hive.box('credentials');

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
    super.initState();
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
    timer = new Timer(Duration(seconds: 3), () async {
      if(box.get('email') != null && box.get('password') != null){
        login();
      }else{
        Get.to(() => LoginScreen());
      }
    });
  }

  login() async {
    await databaseReference.child('Admin').once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapValue = Map.from(snapshot.value);
        if (mapValue['email'].toString() != box.get('email')) {
          Get.to(() => LoginScreen());
        } else if (mapValue['password'].toString() != box.get('password')) {
          Get.to(() => LoginScreen());
        } else {
          getRestaurantDetails();
        }
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }

  getRestaurantDetails() async {
    await databaseReference.child('RestaurantDetails').once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Common.restaurantDetails.value = RestaurantDetailsModel.fromJson(Map.from(snapshot.value));
        Get.offAll(() => HomeScreen());
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
