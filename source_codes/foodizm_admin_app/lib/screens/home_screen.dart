import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/screens/home_fragments/app_settings_fragment.dart';
import 'package:foodizm_admin_app/screens/home_fragments/menu_fragment.dart';
import 'package:foodizm_admin_app/screens/home_fragments/notify_customer_fragment.dart';
import 'package:foodizm_admin_app/screens/home_fragments/orders_fragment.dart';
import 'package:foodizm_admin_app/screens/home_fragments/sales_fragment.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Utils utils = new Utils();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  RxInt navIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showLogoutDialog();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.widgets_outlined, color: AppColors.primaryColor, size: 30),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        body: Obx(() => changeFragment()),
        drawer: Container(width: 250, child: Drawer(child: Column(children: [navHeader(), navMenu()]))),
      ),
    );
  }

  navHeader() {
    return Container(
      height: Get.height / 3,
      width: Get.width,
      color: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: new BoxDecoration(color: AppColors.whiteColor, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryColor)),
            padding: EdgeInsets.all(2),
            child: Common.restaurantDetails.value.logo != 'default'
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: Common.restaurantDetails.value.logo!,
                      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                        height: 50,
                        width: 50,
                        child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                      ),
                      errorWidget: (context, url, error) => SvgPicture.asset('assets/images/man.svg'),
                    ),
                  )
                : SvgPicture.asset('assets/images/man.svg'),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: utils.poppinsMediumText(Common.restaurantDetails.value.name != 'default' ? Common.restaurantDetails.value.name : 'restaurantName'.tr, 13.0,
                AppColors.whiteColor, TextAlign.center),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: utils.poppinsMediumText(
              Common.restaurantDetails.value.phoneNumber != 'default' ? Common.restaurantDetails.value.phoneNumber : 'restaurantNumber'.tr,
              13.0,
              AppColors.whiteColor,
              TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  navMenu() {
    return Expanded(
      child: Container(
        color: AppColors.primaryColor,
        padding: EdgeInsets.only(top: 20),
        child: Obx(() => Column(
              children: [
                InkWell(
                  onTap: () {
                    navIndex.value = 0;
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: drawerItem('nav_orders', 'navOrders'.tr, 0),
                ),
                InkWell(
                  onTap: () {
                    navIndex.value = 1;
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: drawerItem('nav_deals', 'navSales'.tr, 1),
                ),
                InkWell(
                  onTap: () {
                    navIndex.value = 2;
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: drawerItem('nav_menu', 'navMenu'.tr, 2),
                ),
                InkWell(
                  onTap: () {
                    navIndex.value = 3;
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: drawerItem('notification', 'navNotifyCustomer'.tr, 3),
                ),
                InkWell(
                  onTap: () {
                    navIndex.value = 4;
                    scaffoldKey.currentState?.openEndDrawer();
                  },
                  child: drawerItem('nav_settings', 'navAppSettings'.tr, 4),
                ),
              ],
            )),
      ),
    );
  }

  drawerItem(image, title, index) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 5.0, left: 10),
      decoration: BoxDecoration(
        color: navIndex == index ? AppColors.whiteColor : Colors.transparent,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SvgPicture.asset(
              'assets/images/$image.svg',
              height: 25,
              width: 25,
              color: navIndex == index ? AppColors.primaryColor : AppColors.whiteColor,
            ),
          ),
          utils.poppinsMediumText(title, 14.0, navIndex == index ? AppColors.primaryColor : AppColors.whiteColor, TextAlign.start)
        ],
      ),
    );
  }

  changeFragment() {
    switch (navIndex.value) {
      case 0:
        return OrderFragment();
      case 1:
        return SalesFragment();
      case 2:
        return MenuFragment();
      case 3:
        return NotifyCustomerFragment();
      case 4:
        return AppSettingsFragment();
    }
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
