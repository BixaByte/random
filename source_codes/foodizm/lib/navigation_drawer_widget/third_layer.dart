import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/navigation_drawer_widget/home_page.dart';
import 'package:foodizm/navigation_drawer_widget/second_layer.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class ThirdLayer extends StatefulWidget {
  @override
  _ThirdLayerState createState() => _ThirdLayerState();
}

class _ThirdLayerState extends State<ThirdLayer> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            showUserDetails(),
            SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                changeFrag('home'.tr, '0', 'nav_home.svg'),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                changeFrag('menu'.tr, '1', 'nav_menu.svg'),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                changeFrag('myOrders'.tr, '2', 'nav_orders.svg'),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                changeFrag('deals'.tr, '3', 'nav_deals.svg'),
                Padding(padding: EdgeInsets.only(bottom: 20)),
                changeFrag('profile'.tr, '4', 'account.svg'),
                Padding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showUserDetails() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 60,
              width: 60,
              child: utils.getUserId() == null
                  ? SvgPicture.asset('assets/images/man.svg')
                  : Common.userModel.profilePicture != 'default'
                      ? ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.network(Common.userModel.profilePicture!))
                      : SvgPicture.asset('assets/images/man.svg')),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: utils.poppinsMediumText(
              utils.getUserId() == null
                  ? 'fullName'.tr
                  : Common.userModel.fullName != 'default'
                      ? Common.userModel.fullName
                      : 'fullName'.tr,
              13.0,
              AppColors.primaryColor,
              TextAlign.center,
            ),
          ),
          utils.poppinsMediumText(
            utils.getUserId() == null
                ? 'phoneNumber'.tr
                : Common.userModel.phoneNumber != 'default'
                    ? Common.userModel.phoneNumber
                    : 'phoneNumber'.tr,
            13.0,
            AppColors.primaryColor,
            TextAlign.center,
          )
        ],
      ),
    );
  }

  changeFrag(text, index, icon) {
    return InkWell(
      onTap: () {
        Common.name = text;
        Common.homeIndex = index;

        secondLayerState!.xoffSet.value = 0.0;
        secondLayerState!.yoffSet.value = 0.0;
        secondLayerState!.angle.value = 0.0;

        homePageState!.xoffSet.value = 0.0;
        homePageState!.yoffSet.value = 0.0;
        homePageState!.angle.value = 0.0;
        homePageState!.isOpen.value = false;
      },
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/$icon',
            height: 25,
            width: 25,
            color: AppColors.primaryColor,
          ),
          Padding(padding: EdgeInsets.only(left: 10), child: utils.poppinsMediumText(text, 14.0, AppColors.primaryColor, TextAlign.start))
        ],
      ),
    );
  }
}
