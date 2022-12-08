import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/navigation_drawer_widget/first_layer.dart';
import 'package:foodizm/navigation_drawer_widget/home_page.dart';
import 'package:foodizm/navigation_drawer_widget/second_layer.dart';
import 'package:foodizm/navigation_drawer_widget/third_layer.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController? controller;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    if (Utils().getUserId() != null) {
      updateToken();
    }
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    databaseReference.child('Users').child(Utils().getUserId()).update({"userToken": token});
  }

  String time = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (time == '') {
          showLogoutDialog();
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            FirstLayer(),
            SecondLayer(),
            ThirdLayer(),
            HomePage(),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "wantExit".tr,
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("no".tr),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          SystemNavigator.pop();
        },
        child: Text("yes".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }
}
