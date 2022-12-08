import 'package:flutter/material.dart';
import 'package:foodizm/screens/welcome_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';
import '../colors.dart';

class NotLoginWidget extends StatefulWidget {
  final String state;

  NotLoginWidget(this.state);

  @override
  _NotLoginWidgetState createState() => _NotLoginWidgetState();
}

class _NotLoginWidgetState extends State<NotLoginWidget> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return widget.state == 'Dialog'
        ? Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 230,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      alignment: Alignment.centerRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Icon(Icons.close, color: AppColors.whiteColor, size: 20),
                        backgroundColor: AppColors.primaryColor,
                        highlightElevation: 10.0,
                        mini: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: showContainer(),
                    ),
                  ],
                ),
              ),
            ))
        : showContainer();
  }

  showContainer() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/alert.png',
            height: 80,
            width: 80,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'notLogin'.tr,
              softWrap: false,
              style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontFamily: 'HelveticaNeue', fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
              Get.to(() => WelcomeScreen());
            },
            child: Container(
              height: 45,
              width: Get.width,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: Center(child: utils.poppinsMediumText('login'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
            ),
          ),
        ],
      ),
    );
  }
}
