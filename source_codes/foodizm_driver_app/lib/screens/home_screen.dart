import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/common/common.dart';
import 'package:foodizm_driver_app/screens/home_fragments/home_fragment.dart';
import 'package:foodizm_driver_app/screens/home_fragments/order_history_fragment.dart';
import 'package:foodizm_driver_app/screens/home_fragments/profile_fragment.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  RxInt selectedIndex = 0.obs;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Utils().getUserCurrentLocation('');
    updateToken();
  }

  updateToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    databaseReference.child('Drivers').child(Utils().getUserId()).update({"userToken": token});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Utils().driverOfflineMethod();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Utils().getUserCurrentLocation('');
    } else if (state == AppLifecycleState.inactive) {
      Common.locationStream.cancel();
      Utils().driverOfflineMethod();
    } else if (state == AppLifecycleState.paused) {
      Common.locationStream.cancel();
      Utils().driverOfflineMethod();
    }
    print('Current state = $state');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Common.orderModel.length > 0) {
          showAlertDialog();
          return false;
        } else {
          Utils().driverOfflineMethod();
          return true;
        }
      },
      child: Scaffold(
        body: Obx(() => SafeArea(
              child: Stack(
                children: [
                  Container(child: _getPage(selectedIndex.value)),
                  Positioned(
                    child: new Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.all(15.0),
                        child: Card(
                          elevation: 1,
                          shadowColor: AppColors.whiteColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    selectedIndex.value = 0;
                                  },
                                  child: makeBottomWidget('home', 0),
                                ),
                                InkWell(
                                  onTap: () {
                                    selectedIndex.value = 1;
                                  },
                                  child: makeBottomWidget('order_history', 1),
                                ),
                                InkWell(
                                  onTap: () {
                                    selectedIndex.value = 2;
                                  },
                                  child: makeBottomWidget('profile', 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  makeBottomWidget(image, index) {
    return Container(
      width: 40.0,
      height: 40.0,
      padding: EdgeInsets.all(selectedIndex == index ? 10.0 : 7.0),
      decoration: new BoxDecoration(
        color: selectedIndex == index ? AppColors.primaryColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/images/$image.svg',
        color: selectedIndex == index ? AppColors.whiteColor : AppColors.lightGreyColor,
      ),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return HomeFragment();
      case 1:
        return OrderHistoryFragment();
      case 2:
        return ProfileFragment();
    }
  }

  void showAlertDialog() {
    Get.defaultDialog(
      title: "Exit App",
      content: Text(
        "You can't close app while your order is on process",
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("OK"),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
    );
  }


}
