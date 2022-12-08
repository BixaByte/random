import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/categories_model.dart';
import 'package:foodizm/models/product_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/menu_item_widget.dart';
import 'package:get/get.dart';

class MenuFragment extends StatefulWidget {
  const MenuFragment({Key? key}) : super(key: key);

  @override
  _MenuFragmentState createState() => _MenuFragmentState();
}

class _MenuFragmentState extends State<MenuFragment> {
  Utils utils = new Utils();
  RxInt index = 0.obs;
  String categoryId = '';
  RxString categoryName = ''.obs;
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasItems = false.obs;
  RxBool hasCategories = false.obs;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    hasCategories.value = false;
    showCategories();
  }

  showCategories() async {
    Common.allCategoriesList.clear();
    Query query = databaseReference.child('Categories');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.allCategoriesList.add(CategoriesModel.fromJson(Map.from(value)));
        });
      }
      setState(() {
        hasCategories.value = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          utils.poppinsMediumText('foodizm'.tr.toUpperCase(), 18.0, AppColors.lightGrey2Color, TextAlign.start),
          utils.helveticaBoldText('menu'.tr, 22.0, AppColors.lightGrey2Color, TextAlign.start),
          showCategory(),
          Obx(() {
            return Padding(
              padding: EdgeInsets.only(left: 20, top: 15),
              child: utils.poppinsSemiBoldText(categoryName.value, 18.0, AppColors.blackColor, TextAlign.start),
            );
          }),
          Expanded(
            child: Obx(() {
              if (hasItems.value) {
                if (Common.categoryProductList.length > 0) {
                  return Container(
                    margin: EdgeInsets.only(top: 5),
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemCount: Common.categoryProductList.length,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, i) => MenuItemWidget(productModel: Common.categoryProductList[i]),
                    ),
                  );
                } else {
                  return utils.noDataWidget('noDataFound'.tr, Get.height * 0.5);
                }
              } else {
                return Container(
                  height: Get.height * 0.5,
                  child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
                );
              }
            }),
          )
        ],
      ),
    );
  }

  showCategory() {
    if (hasCategories.value) {
      if (Common.allCategoriesList.length > 0) {
        index.value = 0;
        categoryId = Common.allCategoriesList[0].timeCreated!;
        categoryName.value = Common.allCategoriesList[0].title!;
        showCategoryItems(categoryId);
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < Common.allCategoriesList.length; i++)
                  InkWell(
                    onTap: () {
                      addView(Common.allCategoriesList[i].title!);
                      index.value = i;
                      categoryId = Common.allCategoriesList[i].timeCreated!;
                      categoryName.value = Common.allCategoriesList[i].title!;
                      hasItems.value = false;
                      showCategoryItems(categoryId);
                    },
                    child: Obx(() => buildCategories(i, Common.allCategoriesList[i])),
                  ),
              ],
            ),
          ),
        );
      } else {
        return utils.noDataWidget('noDataFound'.tr, 200);
      }
    } else {
      return Container(
        height: 200,
        child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
      );
    }
  }

  buildCategories(int listIndex, CategoriesModel? category) {
    return Container(
      width: 80,
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: index.value == listIndex ? AppColors.primaryColor : AppColors.lightGrey4Color,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 50,
            width: 50,
            padding: EdgeInsets.all(12),
            decoration: new BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
            ),
            child: category!.icon != null && category.icon != 'default'
                ? CachedNetworkImage(
                    imageUrl: category.icon!,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                      height: 30,
                      width: 30,
                      child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                    ),
                    errorWidget: (context, url, error) => SvgPicture.asset('assets/images/burger.svg'),
                  )
                : SvgPicture.asset('assets/images/burger.svg'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: utils.poppinsMediumText1Lines(
                category.title!, 14.0, index.value == listIndex ? AppColors.whiteColor : AppColors.blackColor, TextAlign.center),
          )
        ],
      ),
    );
  }

  showCategoryItems(String categoryId) async {
    Common.categoryProductList.clear();
    Query query = databaseReference.child('Items').orderByChild('categoryId').equalTo(categoryId);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.categoryProductList.add(ProductModel.fromJson(Map.from(value)));
        });
      }
      hasItems.value = true;
    });
  }

  addView(String title) async {
    Query query = databaseReference.child('Categories').orderByChild("title").equalTo(title);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          Query query1 = databaseReference.child('Categories').child(value).child('views').orderByChild('userID').equalTo(utils.getUserId());
          await query1.once().then((DataSnapshot snapshot1) {
            if (!snapshot1.exists) {
              databaseReference.child('Categories').child(value).child('views').push().set({
                'userID': utils.getUserId(),
                'lastView': DateTime.now().millisecondsSinceEpoch.toString(),
              });
              increaseViewCount(value);
            }
          });
        });
      }
    });
  }

  increaseViewCount(String value) async {
    Query query = databaseReference.child('Categories').child(value).child('viewsCount');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        databaseReference.child('Categories').child(value).update({'viewsCount': snapshot.value + 1});
      } else {
        databaseReference.child('Categories').child(value).update({'viewsCount': 1});
      }
    });
  }
}
