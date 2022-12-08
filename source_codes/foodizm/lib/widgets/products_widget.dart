import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/product_model.dart';
import 'package:foodizm/models/variation_model.dart';
import 'package:foodizm/screens/product_detail_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/not_login_widget.dart';
import 'package:foodizm/widgets/select_flavour_widget.dart';
import 'package:foodizm/widgets/select_item_widget.dart';
import 'package:get/get.dart';

class ProductsWidget extends StatefulWidget {
  final ProductModel? productModel;
  final double? width;
  final String? origin;

  const ProductsWidget({Key? key, this.productModel, this.width, this.origin}) : super(key: key);

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  Utils utils = new Utils();
  RxInt itemIndex = 1.obs;
  List<VariationModel>? variationModel = [];
  RxString flavourName = ''.obs;
  RxString variationName = ''.obs;
  RxString variationPrice = ''.obs;

  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    variationModel!.clear();
    for (int i = 0; i < widget.productModel!.customizationForVariations!.length; i++) {
      Map<String, dynamic> mapOfMaps = Map.from(widget.productModel!.customizationForVariations![i]!);
      variationModel!.add(VariationModel.fromJson(Map.from(mapOfMaps)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addView();
        Get.to(() => ProductDetailScreen(type: 'Items', productModel: widget.productModel, dealsModel: null));
      },
      child: Container(
        width: widget.width,
        margin: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, widget.width == 250.0 ? 10.0 : 0.0, 10.0),
        child: Card(
          elevation: 2,
          shadowColor: AppColors.paymentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                  child: widget.productModel!.image != null && widget.productModel!.image != 'default'
                      ? CachedNetworkImage(
                          height: 120,
                          width: widget.width,
                          fit: BoxFit.cover,
                          imageUrl: widget.productModel!.image!,
                          progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                            height: 50,
                            width: 50,
                            child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/placeholder_image.png", height: 120, width: widget.width, fit: BoxFit.cover),
                        )
                      : Image.asset("assets/images/placeholder_image.png", height: 120, width: widget.width, fit: BoxFit.cover),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: utils.helveticaSemiBold2Lines(widget.productModel!.title!, 13.0, AppColors.blackColor, TextAlign.start),
                    ),
                  ),
                  if (widget.origin == 'popular')
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 16.0,
                            color: AppColors.lightGreyColor,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 5.0, 0.0),
                            child: utils.poppinsRegularText(
                                widget.productModel!.viewsCount != null ? widget.productModel!.viewsCount!.toString() : '0',
                                10.0,
                                AppColors.lightGrey2Color,
                                TextAlign.start),
                          ),
                        ],
                      ),
                    )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    utils.poppinsSemiBoldText(Common.currency + widget.productModel!.price!, 13.0, AppColors.primaryColor, TextAlign.start),
                    utils.poppinsRegularText('Serving ${widget.productModel!.noOfServing!} guest', 12.0, AppColors.lightGreyColor, TextAlign.start),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: InkWell(
                              onTap: () {
                                if (itemIndex > 1) {
                                  itemIndex.value = itemIndex.value - 1;
                                }
                              },
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: AppColors.primaryColor,
                                size: 27.0,
                              ),
                            ),
                          ),
                          utils.poppinsSemiBoldText('$itemIndex', 16.0, AppColors.blackColor, TextAlign.center),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: InkWell(
                              onTap: () {
                                itemIndex.value = itemIndex.value + 1;
                              },
                              child: Icon(
                                Icons.add_circle_outlined,
                                color: AppColors.primaryColor,
                                size: 27.0,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    InkWell(
                      onTap: () {
                        if (utils.getUserId() == null) {
                          showDialog(
                            context: context,
                            builder: (_) => NotLoginWidget('Dialog'),
                          );
                        } else {
                          if (widget.productModel!.customizationForFlavours![0] != 'default') {
                            showSelectDialog();
                          } else if (variationModel![0].name != 'default') {
                            showSelectDialog();
                          } else {
                            addToCart();
                          }
                        }
                      },
                      child: Container(
                        height: 35,
                        width: 38,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft, end: Alignment.topRight, colors: [AppColors.primaryColor, AppColors.primaryColor]),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSelectDialog() {
    Get.defaultDialog(
      title: "select".tr,
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 400),
        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.productModel!.customizationForFlavours![0] != 'default'
                  ? SelectFlavourWidget(
                      flavours: widget.productModel!.customizationForFlavours!,
                      function: (String name) {
                        flavourName.value = name;
                      },
                    )
                  : Container(),
              variationModel![0].name != 'default'
                  ? SelectItemWidget(
                      variationModel: variationModel!,
                      function: (String name, String price) {
                        variationName.value = name;
                        variationPrice.value = price;
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          addToCart();
        },
        child: Text("addToCart".tr),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
    );
  }

  void addToCart() async {
    utils.showLoadingDialog();
    String timeAdded = DateTime.now().millisecondsSinceEpoch.toString();
    List<String>? customizationForFlavours = [];
    List<Map<String, dynamic>?>? customizationForVariations = [];
    if (widget.productModel!.customizationForFlavours![0] != 'default') {
      List<String> flavours = [];
      flavours.add(flavourName.value);
      customizationForFlavours = flavours;
    } else {
      customizationForFlavours = widget.productModel!.customizationForFlavours;
    }

    if (variationModel![0].name != 'default') {
      List<Map<String, dynamic>?>? variationModel = [];
      variationModel.add({'name': variationName.value, 'price': variationPrice.value});
      customizationForVariations = variationModel;
    } else {
      customizationForVariations = widget.productModel!.customizationForVariations;
    }

    Map<dynamic, dynamic> data = {
      "categoryId": widget.productModel!.categoryId!,
      "title": widget.productModel!.title!,
      "details": widget.productModel!.details!,
      "image": widget.productModel!.image!,
      "type": widget.productModel!.type!,
      "no_of_serving": widget.productModel!.noOfServing!,
      "timeCreated": widget.productModel!.timeCreated!,
      "newPrice": widget.productModel!.price!,
      "quantity": itemIndex.value.toString(),
      "uid": utils.getUserId(),
      "timeAdded": timeAdded,
      "ingredients": widget.productModel!.ingredients!,
      "customizationForVariations": customizationForVariations,
      "customizationForFlavours": customizationForFlavours
    };

    Query query = databaseReference.child('Cart').orderByChild('timeCreated').equalTo(widget.productModel!.timeCreated!);
    await query.once().then((DataSnapshot snapshot) {
      if (!snapshot.exists) {
        databaseReference.child('Cart').push().set(data);
        Get.back();
        utils.showToast('itemAddedInCart'.tr);
      } else {
        List<String> uid = [];
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          uid.add(value['uid']);
        });

        if (uid.contains(utils.getUserId())) {
          increaseItemQuantity();
        } else {
          databaseReference.child('Cart').push().set(data);
          Get.back();
          utils.showToast('itemAddedInCart'.tr);
        }
      }
    });
  }

  increaseItemQuantity() async {
    Query query = databaseReference.child('Cart').orderByChild('timeCreated').equalTo(widget.productModel!.timeCreated!);
    query.once().then((DataSnapshot snapshot) {
      Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
      mapOfMaps.values.forEach((value) {
        if (value['uid'].toString() == utils.getUserId()) {
          var encoded = jsonEncode(snapshot.value);
          var decoded = jsonDecode(encoded);
          databaseReference.child('Cart').child(decoded.keys.toString().replaceAll('(', '').replaceAll(')', '')).update({
            'quantity': (int.parse(value['quantity']) + itemIndex.value).toString(),
          });
          Get.back();
          utils.showToast('itemAddedInCart'.tr);
        }
      });
    });
  }

  addView() async {
    Query query = databaseReference.child('Items').orderByChild("title").equalTo(widget.productModel!.title!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          Query query1 = databaseReference.child('Items').child(value).child('views').orderByChild('userID').equalTo(utils.getUserId());
          await query1.once().then((DataSnapshot snapshot1) {
            if (!snapshot1.exists) {
              databaseReference.child('Items').child(value).child('views').push().set({
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
    Query query = databaseReference.child('Items').child(value).child('viewsCount');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        databaseReference.child('Items').child(value).update({'viewsCount': snapshot.value + 1});
      } else {
        databaseReference.child('Items').child(value).update({'viewsCount': 1});
      }
    });
  }
}
