import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/categories_model.dart';
import 'package:foodizm/models/deals_model.dart';
import 'package:foodizm/models/product_model.dart';
import 'package:foodizm/screens/category_item_screen.dart';
import 'package:foodizm/screens/see_all_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/deals_widget.dart';
import 'package:foodizm/widgets/products_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasCategories = false.obs;
  RxBool hasDeals = false.obs;
  RxBool hasPopular = false.obs;
  RxBool hasLatest = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    hasCategories.value = false;
    hasDeals.value = false;
    hasPopular.value = false;
    hasLatest.value = false;
    showCategories();
    showDeals();
    showPopularItems();
    showLatestItems();
  }

  showCategories() async {
    Common.categoriesList.clear();
    Query query = databaseReference.child('Categories').orderByChild('viewsCount').limitToLast(4);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.categoriesList.add(CategoriesModel.fromJson(Map.from(value)));
        });
      }
      hasCategories.value = true;
    });
  }

  showDeals() async {
    Common.dealsList.clear();
    String date = DateFormat("dd-MMM-yyyy").format(DateTime.now());
    Query query = databaseReference.child('Deals').orderByChild('viewsCount');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          if (DateTime.now().isAfter(DateFormat("dd-MMM-yyyy").parse(value['validDate']))) {
            if (DateTime.now().isBefore(DateFormat("dd-MMM-yyyy").parse(value['expiryDate']))) {
              Common.dealsList.add(DealsModel.fromJson(Map.from(value)));
            }
          } else if (date == DateFormat("dd-MMM-yyyy").format(value['validDate'])) {
            Common.dealsList.add(DealsModel.fromJson(Map.from(value)));
          } else if (date == DateFormat("dd-MMM-yyyy").format(value['expiryDate'])) {
            Common.dealsList.add(DealsModel.fromJson(Map.from(value)));
          }
        });
      }
      hasDeals.value = true;
    });
  }

  showPopularItems() async {
    Common.popularProductList.clear();
    Query query = databaseReference.child('Items').orderByChild('viewsCount');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.popularProductList.add(ProductModel.fromJson(Map.from(value)));
        });
      }
      hasPopular.value = true;
    });
  }

  showLatestItems() async {
    Common.latestProductList.clear();
    Query query = databaseReference.child('Items').orderByChild('timeCreated');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.latestProductList.add(ProductModel.fromJson(Map.from(value)));
        });
      }
      hasLatest.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.primaryColor,
      color: AppColors.whiteColor,
      onRefresh: () async {
        await getData();
        return;
      },
      child: Container(
        color: AppColors.whiteColor,
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              utils.poppinsMediumText('welcomeTo'.tr, 18.0, AppColors.lightGrey2Color, TextAlign.start),
              utils.helveticaBoldText('foodizm'.tr.toUpperCase(), 22.0, AppColors.lightGrey2Color, TextAlign.start),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: utils.poppinsSemiBoldText('topCategories'.tr, 20.0, AppColors.blackColor, TextAlign.start),
              ),
              Obx(() {
                if (hasCategories.value) {
                  if (Common.categoriesList.length > 0) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < Common.categoriesList.length; i++) buildCategories(Common.categoriesList[i]),
                        ],
                      ),
                    );
                  } else {
                    return utils.noDataWidget('noCategoriesFound'.tr, 150);
                  }
                } else {
                  return Container(
                    height: 150,
                    child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
                  );
                }
              }),
              Obx(() {
                if (hasDeals.value) {
                  if (Common.dealsList.length > 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              utils.poppinsSemiBoldText('deals'.tr, 20.0, AppColors.blackColor, TextAlign.start),
                              if (Common.dealsList.length > 5)
                                InkWell(
                                  onTap: () {
                                    Get.to(() => SeeAllScreen(title: 'All Deals'));
                                  },
                                  child: utils.poppinsMediumText('seeAll'.tr, 14.0, AppColors.primaryColor, TextAlign.end),
                                )
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0; i < showDealsLength(); i++) DealsWidget(dealsModel: Common.dealsList[i], width: 200.0),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return utils.noDataWidget('noDealsFound'.tr, 200);
                  }
                } else {
                  return Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
                  );
                }
              }),
              Obx(() {
                if (hasPopular.value) {
                  if (Common.popularProductList.length > 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              utils.poppinsSemiBoldText('popular'.tr, 20.0, AppColors.blackColor, TextAlign.start),
                              if (Common.popularProductList.length > 5)
                                InkWell(
                                  onTap: () {
                                    Get.to(() => SeeAllScreen(title: 'All Popular'));
                                  },
                                  child: utils.poppinsMediumText('seeAll'.tr, 14.0, AppColors.primaryColor, TextAlign.end),
                                )
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0; i < showPopularLength(); i++)
                                ProductsWidget(productModel: Common.popularProductList[i], width: 200.0, origin: 'popular'),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return utils.noDataWidget('noItemsFound'.tr, 200);
                  }
                } else {
                  return Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
                  );
                }
              }),
              Obx(() {
                if (hasLatest.value) {
                  if (Common.latestProductList.length > 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              utils.poppinsSemiBoldText('latestDishes'.tr, 20.0, AppColors.blackColor, TextAlign.start),
                              if (Common.latestProductList.length > 5)
                                InkWell(
                                  onTap: () {
                                    Get.to(() => SeeAllScreen(title: 'All Latest Dishes'));
                                  },
                                  child: utils.poppinsMediumText('seeAll'.tr, 14.0, AppColors.primaryColor, TextAlign.end),
                                )
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0; i < showPopularLength(); i++)
                                ProductsWidget(productModel: Common.latestProductList[i], width: 200.0, origin: 'latest'),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return utils.noDataWidget('noItemsFound'.tr, 200);
                  }
                } else {
                  return Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  buildCategories(CategoriesModel categoriesModel) {
    return InkWell(
      onTap: () {
        addView(categoriesModel.title!);
        Get.to(() => CategoryItemScreen(categoriesModel: categoriesModel, title: categoriesModel.title));
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

  showDealsLength() {
    int length = 0;
    if (Common.dealsList.length > 5) {
      length = 5;
    } else {
      length = Common.dealsList.length;
    }
    return length;
  }

  showPopularLength() {
    int length = 0;
    if (Common.popularProductList.length > 5) {
      length = 5;
    } else {
      length = Common.popularProductList.length;
    }
    return length;
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
