import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/common/common.dart';
import 'package:foodizm_driver_app/screens/login_screen.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('settings'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: _body('About Us'),
              ),
              InkWell(
                onTap: () {},
                child: _body('Terms & Conditions'),
              ),
              InkWell(
                onTap: () {},
                child: _body('Privacy Policy'),
              ),
              InkWell(
                onTap: () {
                  if (Common.orderModel.length > 0) {
                    showAlertDialog(0);
                  } else {
                    showAlertDialog(1);
                  }
                },
                child: _body('logout'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _body(text) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                child: utils.poppinsMediumText(text, 14.0, Colors.grey, TextAlign.left),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 20)
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Divider(height: 10.0, color: AppColors.lightGreyColor),
        ),
      ],
    );
  }

  void showAlertDialog(index) {
    Get.defaultDialog(
      title: index == 1 ? "Confirmation" : "Exit App",
      content: Text(
        index == 1 ? "Do you want to logout?" : "You can't close app while your order is on process",
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text(index == 1 ? "No" : "Ok"),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
      confirm: index == 1
          ? ElevatedButton(
              onPressed: () async {
                Hive.box('credentials').deleteFromDisk();
                Get.offAll(() => LoginScreen());
              },
              child: Text("Yes"),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            )
          : SizedBox(),
    );
  }
}
