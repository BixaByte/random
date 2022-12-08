import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/deals_model.dart';
import 'package:foodizm_admin_app/database_model/product_model.dart';
import 'package:foodizm_admin_app/screens/add_deal_screen.dart';
import 'package:foodizm_admin_app/screens/add_product_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/deals_widget.dart';
import 'package:foodizm_admin_app/widget/products_widget.dart';
import 'package:get/get.dart';

class ProductsScreen extends StatefulWidget {
  final String? title;

  const ProductsScreen({Key? key, this.title}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasDeals = false.obs;
  RxBool hasProducts = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    if (widget.title == 'All Products') {
      showItems();
    } else {
      showDeals();
    }
  }

  showDeals() async {
    Common.dealsList.clear();
    Query query = databaseReference.child('Deals');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.dealsList.add(DealsModel.fromJson(Map.from(value)));
        });
      }
      hasDeals.value = true;
    });
  }

  showItems() async {
    Common.productList.clear();
    Query query = databaseReference.child('Items');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.productList.add(ProductModel.fromJson(Map.from(value)));
        });
      }
      hasProducts.value = true;
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
        title: utils.poppinsMediumText(widget.title, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              if (widget.title == 'All Products')
                Get.to(() => AddProductScreen(origin: 'add'))!.then((value) {
                  hasProducts.value = false;
                  showItems();
                });
              else if (widget.title == 'All Deals')
                Get.to(() => AddDealScreen(origin: 'add'))!.then((value) {
                  hasDeals.value = false;
                  showDeals();
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
        if (widget.title == 'All Products') {
          if (hasProducts.value) {
            if (Common.productList.length > 0) {
              return showData(Common.productList.length);
            } else {
              return utils.noDataWidget('No Data Found', Get.height);
            }
          } else {
            return Container(
              height: Get.height,
              child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
            );
          }
        } else {
          if (hasDeals.value) {
            if (Common.dealsList.length > 0) {
              return showData(Common.dealsList.length);
            } else {
              return utils.noDataWidget('No Data Found', Get.height);
            }
          } else {
            return Container(
              height: Get.height,
              child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
            );
          }
        }
      }),
    );
  }

  showData(int length) {
    return Container(
      margin: EdgeInsets.all(10),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        crossAxisCount: 2,
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        itemCount: length,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, i) => showWidget(i),
      ),
    );
  }

  showWidget(int i) {
    if (widget.title == 'All Deals')
      return InkWell(
        onTap: () {
          Get.to(() => AddDealScreen(origin: 'edit', dealsModel: Common.dealsList[i]))!.then((value) {
            showDeals();
          });
        },
        child: DealsWidget(dealsModel: Common.dealsList[i]),
      );
    if (widget.title == 'All Products')
      return InkWell(
        onTap: () {
          Get.to(() => AddProductScreen(origin: 'edit', productModel: Common.productList[i]))!.then((value) {
            showItems();
          });
        },
        child: ProductsWidget(productModel: Common.productList[i]),
      );
  }
}
