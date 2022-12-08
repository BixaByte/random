import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/navigation_drawer_widget/second_layer.dart';
import 'package:foodizm/screens/cart_screen.dart';
import 'package:foodizm/screens/category_item_screen.dart';
import 'package:foodizm/screens/home_fragments/deals_fragment.dart';
import 'package:foodizm/screens/home_fragments/home_fragment.dart';
import 'package:foodizm/screens/home_fragments/menu_fragment.dart';
import 'package:foodizm/screens/home_fragments/orders_fragment.dart';
import 'package:foodizm/screens/home_fragments/profile_fragment.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

HomePageState? homePageState;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Utils utils = new Utils();
  RxDouble xoffSet = 0.0.obs;
  RxDouble yoffSet = 0.0.obs;
  RxDouble angle = 0.0.obs;
  RxBool isOpen = false.obs;
  RxBool showSearch = true.obs;

  @override
  Widget build(BuildContext context) {
    homePageState = this;
    return Obx(() {
      return AnimatedContainer(
        transform: Matrix4Transform().translate(x: xoffSet.value, y: yoffSet.value).rotate(angle.value).matrix4,
        duration: Duration(milliseconds: 250),
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: isOpen.value ? BorderRadius.circular(10) : BorderRadius.circular(0)),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              elevation: 0,
              leading: !isOpen.value
                  ? IconButton(
                      icon: Icon(
                        Icons.widgets_outlined,
                        color: AppColors.primaryColor,
                        size: 30,
                      ),
                      onPressed: () {
                        xoffSet.value = 150.0;
                        yoffSet.value = 80.0;
                        angle.value = -0.2;
                        isOpen.value = true;

                        secondLayerState!.xoffSet.value = 122.0;
                        secondLayerState!.yoffSet.value = 110.0;
                        secondLayerState!.angle.value = -0.275;
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
                      onPressed: () {
                        xoffSet.value = 0;
                        yoffSet.value = 0;
                        angle.value = 0;
                        isOpen.value = false;

                        secondLayerState!.xoffSet.value = 0.0;
                        secondLayerState!.yoffSet.value = 0.0;
                        secondLayerState!.angle.value = 0.0;
                      },
                    ),
              actions: <Widget>[
                Obx(() {
                  if (showSearch.value) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => CategoryItemScreen(title: 'Search'));
                      },
                      child: SvgPicture.asset('assets/images/search.svg', height: 25, width: 25),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
                InkWell(
                  onTap: () {
                    Get.to(() => CartScreen());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset('assets/images/cart.svg', height: 30, width: 30),
                  ),
                )
              ],
            ),
            body: changePage(),
          ),
        ),
      );
    });
  }

  changePage() {
    switch (Common.homeIndex) {
      case '0':
        showSearch.value = true;
        return HomeFragment();
      case '1':
        showSearch.value = true;
        return MenuFragment();
      case '2':
        showSearch.value = false;
        return OrdersFragment();
      case '3':
        showSearch.value = false;
        return DealsFragment();
      case '4':
        showSearch.value = false;
        return ProfileFragment();
    }
  }
}
