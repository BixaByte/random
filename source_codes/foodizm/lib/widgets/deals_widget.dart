import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/deals_model.dart';
import 'package:foodizm/screens/product_detail_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/not_login_widget.dart';
import 'package:foodizm/widgets/select_drink_widget.dart';
import 'package:foodizm/widgets/select_flavour_widget.dart';
import 'package:get/get.dart';

class DealsWidget extends StatefulWidget {
  final DealsModel? dealsModel;
  final double? width;

  const DealsWidget({Key? key, this.dealsModel, this.width}) : super(key: key);

  @override
  _DealsWidgetState createState() => _DealsWidgetState();
}

class _DealsWidgetState extends State<DealsWidget> {
  Utils utils = new Utils();
  RxInt itemIndex = 1.obs;
  RxString flavourName = ''.obs;
  RxString drinkName = ''.obs;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addView();
        Get.to(() => ProductDetailScreen(type: 'Deals', dealsModel: widget.dealsModel, productModel: null));
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
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                        child: widget.dealsModel!.image != null && widget.dealsModel!.image != 'default'
                            ? CachedNetworkImage(
                                height: 120,
                                width: widget.width,
                                fit: BoxFit.cover,
                                imageUrl: widget.dealsModel!.image!,
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
                    Align(
                      alignment: Alignment.topRight,
                      child: Card(
                        color: AppColors.redColor,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: utils.poppinsMediumText('${widget.dealsModel!.discount!} %', 12.0, AppColors.whiteColor, TextAlign.center),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                child: utils.helveticaSemiBold2Lines(widget.dealsModel!.title!, 13.0, AppColors.blackColor, TextAlign.start),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        utils.poppinsSemiBoldText(Common.currency + widget.dealsModel!.newPrice!, 13.0, AppColors.primaryColor, TextAlign.start),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: utils.poppinsRegularTextLineTrough(
                              Common.currency + widget.dealsModel!.oldPrice!, 10.0, AppColors.lightGreyColor, TextAlign.start),
                        )
                      ],
                    ),
                    utils.poppinsRegularText('Serving ${widget.dealsModel!.noOfServing!} guest', 12.0, AppColors.lightGreyColor, TextAlign.start),
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
                          if (widget.dealsModel!.customizationForFlavours![0] != 'default') {
                            showSelectDialog();
                          } else if (widget.dealsModel!.customizationForDrinks![0] != 'default') {
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
              widget.dealsModel!.customizationForDrinks![0] != 'default'
                  ? SelectDrinkWidget(
                      drinks: widget.dealsModel!.customizationForDrinks!,
                      function: (String name) {
                        drinkName.value = name;
                      },
                    )
                  : Container(),
              widget.dealsModel!.customizationForFlavours![0] != 'default'
                  ? SelectFlavourWidget(
                      flavours: widget.dealsModel!.customizationForFlavours!,
                      function: (String name) {
                        flavourName.value = name;
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
    List<String>? customizationForDrinks = [];
    if (widget.dealsModel!.customizationForFlavours![0] != 'default') {
      List<String> flavours = [];
      flavours.add(flavourName.value);
      customizationForFlavours = flavours;
    } else {
      customizationForFlavours = widget.dealsModel!.customizationForFlavours;
    }

    if (widget.dealsModel!.customizationForDrinks![0] != 'default') {
      List<String> drinks = [];
      drinks.add(drinkName.value);
      customizationForDrinks = drinks;
    } else {
      customizationForDrinks = widget.dealsModel!.customizationForDrinks;
    }

    Map<dynamic, dynamic> data = {
      "categoryId": 'default',
      "title": widget.dealsModel!.title!,
      "details": widget.dealsModel!.details!,
      "image": widget.dealsModel!.image!,
      "type": widget.dealsModel!.type!,
      "no_of_serving": widget.dealsModel!.noOfServing!,
      "timeCreated": widget.dealsModel!.timeCreated!,
      "discount": widget.dealsModel!.discount!,
      "expiryDate": widget.dealsModel!.expiryDate!,
      "validDate": widget.dealsModel!.validDate!,
      "newPrice": widget.dealsModel!.newPrice!,
      "oldPrice": widget.dealsModel!.oldPrice!,
      "quantity": itemIndex.value.toString(),
      "uid": utils.getUserId(),
      "timeAdded": timeAdded,
      "itemsIncluded": widget.dealsModel!.itemsIncluded!,
      "customizationForDrinks": customizationForDrinks,
      "customizationForFlavours": customizationForFlavours
    };

    Query query = databaseReference.child('Cart').orderByChild('timeCreated').equalTo(widget.dealsModel!.timeCreated!);
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
    Query query = databaseReference.child('Cart').orderByChild('timeCreated').equalTo(widget.dealsModel!.timeCreated!);
    query.once().then((DataSnapshot snapshot) {
      Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
      mapOfMaps.values.forEach((value) {
        if (value['uid'].toString() == utils.getUserId()) {
          var encoded = jsonEncode(snapshot.value);
          var decoded = jsonDecode(encoded);
          utils.showToast(decoded.keys.toString());
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
    Query query = databaseReference.child('Deals').orderByChild("title").equalTo(widget.dealsModel!.title!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          Query query1 = databaseReference.child('Deals').child(value).child('views').orderByChild('userID').equalTo(utils.getUserId());
          await query1.once().then((DataSnapshot snapshot1) {
            if (!snapshot1.exists) {
              databaseReference.child('Deals').child(value).child('views').push().set({
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
    Query query = databaseReference.child('Deals').child(value).child('viewsCount');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        databaseReference.child('Deals').child(value).update({'viewsCount': snapshot.value + 1});
      } else {
        databaseReference.child('Deals').child(value).update({'viewsCount': 1});
      }
    });
  }
}
