import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/categories_model.dart';
import 'package:foodizm_admin_app/screens/categories_screen.dart';
import 'package:foodizm_admin_app/screens/products_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';

class MenuFragment extends StatefulWidget {
  const MenuFragment({Key? key}) : super(key: key);

  @override
  _MenuFragmentState createState() => _MenuFragmentState();
}

class _MenuFragmentState extends State<MenuFragment> {
  Utils utils = new Utils();
  RxString? totalCategory = '0'.obs;
  RxString? totalItems = '0'.obs;
  RxString? totalDeals = '0'.obs;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    Common.categoriesList.clear();
    await databaseReference.child('Categories').once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map data = snapshot.value;
        totalCategory!.value = data.length.toString();
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.categoriesList.add(CategoriesModel.fromJson(Map.from(value)));
        });
      }
    });
    await databaseReference.child('Items').once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map data = snapshot.value;
        totalItems!.value = data.length.toString();
      }
    });
    await databaseReference.child('Deals').once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map data = snapshot.value;
        totalDeals!.value = data.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          utils.helveticaBoldText('menu'.tr, 22.0, AppColors.blackColor, TextAlign.start),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Get.to(() => CategoriesScreen())!.then((value) {
                  getData();
                });
              },
              child: Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    utils.poppinsMediumText('categories'.tr, 25.0, AppColors.whiteColor, TextAlign.center),
                    Obx(() => utils.poppinsMediumText(totalCategory!.value, 30.0, AppColors.whiteColor, TextAlign.center)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Get.to(() => ProductsScreen(title: 'All Products'))!.then((value) {
                  getData();
                });
              },
              child: Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: AppColors.blueColor, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    utils.poppinsMediumText('items'.tr, 25.0, AppColors.whiteColor, TextAlign.center),
                    Obx(() => utils.poppinsMediumText(totalItems!.value, 30.0, AppColors.whiteColor, TextAlign.center)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Get.to(() => ProductsScreen(title: 'All Deals'))!.then((value) {
                  getData();
                });
              },
              child: Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(color: AppColors.googleColor, borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    utils.poppinsMediumText('deals'.tr, 25.0, AppColors.whiteColor, TextAlign.center),
                    Obx(() => utils.poppinsMediumText(totalDeals!.value, 30.0, AppColors.whiteColor, TextAlign.center)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
