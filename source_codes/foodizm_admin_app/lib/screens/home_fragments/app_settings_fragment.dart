import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/screens/delivery_charges_screen.dart';
import 'package:foodizm_admin_app/screens/login_screen.dart';
import 'package:foodizm_admin_app/screens/restaurant_details_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AppSettingsFragment extends StatefulWidget {
  const AppSettingsFragment({Key? key}) : super(key: key);

  @override
  _AppSettingsFragmentState createState() => _AppSettingsFragmentState();
}

class _AppSettingsFragmentState extends State<AppSettingsFragment> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            color: Colors.grey.shade100,
            child: Center(
              child: utils.poppinsMediumText('appSettings'.tr, 14.0, AppColors.lightGrey2Color, TextAlign.center),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => RestaurantDetailsScreen());
            },
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: subTitle('restaurantDetails'.tr, Icons.arrow_forward_ios),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => DeliveryChargesScreen());
            },
            child: subTitle('deliveryCharges'.tr, Icons.arrow_forward_ios),
          ),
          subTitle('appVersion'.tr, Icons.arrow_forward_ios),
          InkWell(
            onTap: () {
              showLogoutDialog();
            },
            child: subTitle('logout'.tr, Icons.logout),
          ),
        ],
      ),
    );
  }

  subTitle(title, icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          utils.poppinsMediumText(title, 16.0, AppColors.lightGrey2Color, TextAlign.center),
          if (title != 'appVersion'.tr) Icon(icon, color: AppColors.lightGrey2Color, size: 20.0),
          if (title == 'appVersion'.tr) utils.poppinsMediumText('1.0.1', 14.0, AppColors.lightGrey2Color, TextAlign.center),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "wantLogout".tr,
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
          Hive.box('credentials').deleteFromDisk();
          Get.offAll(() => LoginScreen());
        },
        child: Text("yes".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }
}
