import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/categories_model.dart';
import 'package:foodizm_admin_app/screens/add_category_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasCategories = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCategories();
  }

  showCategories() async {
    Common.categoriesList.clear();
    await databaseReference.child('Categories').once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.categoriesList.add(CategoriesModel.fromJson(Map.from(value)));
        });
      }
      hasCategories.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('allCategories'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => AddCategoryScreen(origin: 'add'))!.then((value) {
                showCategories();
              });
            },
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: SvgPicture.asset('assets/images/add.svg'),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (hasCategories.value) {
          if (Common.categoriesList.length > 0) {
            return Container(
              margin: EdgeInsets.all(10),
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                crossAxisCount: 2,
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                itemCount: Common.categoriesList.length,
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, i) => buildCategories(Common.categoriesList[i]),
              ),
            );
          } else {
            return utils.noDataWidget('noCategories'.tr, Get.height);
          }
        } else {
          return Container(
            height: Get.height,
            child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
          );
        }
      }),
    );
  }

  buildCategories(CategoriesModel categoriesModel) {
    return InkWell(
      onTap: () {
        Get.to(() => AddCategoryScreen(origin: 'edit', categoriesModel: categoriesModel))!.then((value) {
          showCategories();
        });
      },
      child: Container(
        height: 150,
        width: 140,
        margin: EdgeInsets.only(right: 10),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(flex: 2, child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: Card(
                    color: HexColor(categoriesModel.colorCode!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Expanded(flex: 3, child: SizedBox()),
                        Expanded(
                          flex: 7,
                          child: Center(
                            child: utils.poppinsMediumText(categoriesModel.title!, 14.0, AppColors.whiteColor, TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 105,
                width: 105,
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: categoriesModel.image != null
                      ? CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: categoriesModel.image!,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                            height: 50,
                            width: 50,
                            child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                          ),
                          errorWidget: (context, url, error) => Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
                        )
                      : Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
