import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/models/categories_model.dart';
import 'package:foodizm/models/product_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/menu_item_widget.dart';
import 'package:get/get.dart';

class CategoryItemScreen extends StatefulWidget {
  final CategoriesModel? categoriesModel;
  final String? title;

  const CategoryItemScreen({Key? key, this.categoriesModel, this.title}) : super(key: key);

  @override
  _CategoryItemScreenState createState() => _CategoryItemScreenState();
}

class _CategoryItemScreenState extends State<CategoryItemScreen> {
  Utils utils = new Utils();
  var searchController = new TextEditingController();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> searchProductList = <ProductModel>[].obs;
  RxBool hasItems = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showCategoryItems(widget.title != 'Search' ? widget.categoriesModel!.timeCreated! : '');
  }

  showCategoryItems(String categoryId) async {
    productList.clear();
    Query query;
    if (widget.title == 'Search') {
      query = databaseReference.child('Items');
    } else {
      query = databaseReference.child('Items').orderByChild('categoryId').equalTo(categoryId);
    }
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          productList.add(ProductModel.fromJson(Map.from(value)));
        });
      }
      hasItems.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText(widget.title, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (widget.title == 'Search')
            Container(
              margin: EdgeInsets.all(15),
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), border: Border.all(color: AppColors.primaryColor)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.search, color: Colors.grey, size: 20),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextFormField(
                      controller: searchController,
                      onChanged: onSearchTextChanged,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 14),
                        hintText: 'search'.tr,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.title != 'Search') SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (hasItems.value) {
                if (productList.length > 0) {
                  return Container(
                    margin: EdgeInsets.only(top: 5),
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      itemCount: searchProductList.length < 0 || searchController.text.isEmpty ? productList.length : searchProductList.length,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, i) => MenuItemWidget(
                          productModel: searchProductList.length < 0 || searchController.text.isEmpty ? productList[i] : searchProductList[i]),
                    ),
                  );
                } else {
                  return utils.noDataWidget('noData'.tr, Get.height * 0.5);
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

  onSearchTextChanged(String text) async {
    searchProductList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    productList.forEach((products) {
      if (products.title!.toLowerCase().contains(text.toLowerCase())) searchProductList.add(products);
    });

    setState(() {});
  }
}
