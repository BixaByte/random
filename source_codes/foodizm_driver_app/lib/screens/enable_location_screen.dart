import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:get/get.dart';

class EnableLocationScreen extends StatefulWidget {
  const EnableLocationScreen({Key? key}) : super(key: key);

  @override
  _EnableLocationScreenState createState() => _EnableLocationScreenState();
}

class _EnableLocationScreenState extends State<EnableLocationScreen> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/enable_location.svg',
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  utils.poppinsBoldText('Hi! Nice to meet you', 24.0, AppColors.blackColor, TextAlign.center),
                  utils.poppinsRegularText('Please allow location in order to\nenjoy this app', 14.0, AppColors.lightGrey2Color, TextAlign.center),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    utils.getUserCurrentLocation('location');
                  },
                  child: Container(
                    height: 40,
                    width: Get.width,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    child: Center(child: utils.poppinsMediumText('Enable Location', 16.0, AppColors.primaryColor, TextAlign.center)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
