import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/cart_model.dart';
import 'package:foodizm/screens/checkout_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/cart_item_widget.dart';
import 'package:foodizm/widgets/not_login_widget.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;
  double cartTotalPrice = 0.0;
  RxString grandTotalPrice = '0'.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (utils.getUserId() != null) {
      showCart();
    }
  }

  showCart() async {
    Common.cartModel.clear();
    Query query = databaseReference.child('Cart').orderByChild('uid').equalTo(utils.getUserId());
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.cartModel.add(CartModel.fromJson(Map.from(value)));
        });
      }
      hasData.value = true;
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
        title: utils.poppinsMediumText('myCart'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: utils.getUserId() == null
          ? NotLoginWidget('')
          : Obx(() {
              if (hasData.value) {
                if (Common.cartModel.length > 0) {
                  grandTotal();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < Common.cartModel.length; i++) CartItemWidget(cartModel: Common.cartModel[i], function: function),
                        Obx(() => Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                              child: utils.poppinsSemiBoldText(
                                  'total'.tr + ' : ' + Common.currency + grandTotalPrice.value, 16.0, AppColors.blackColor, TextAlign.end),
                            )),
                        InkWell(
                          onTap: () {
                            Get.to(() => CheckoutScreen(totalPrice: grandTotalPrice.value));
                          },
                          child: Container(
                            height: 40,
                            width: Get.width,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              border: Border.all(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            ),
                            child: Center(child: utils.poppinsMediumText('placeOrder'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                          ),
                        ),
                        SizedBox(height: 50)
                      ],
                    ),
                  );
                } else {
                  return utils.noDataWidget('emptyCart'.tr, Get.height);
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

  function(quantity, event, price) {
    if (event == 'add')
      calculateAddPrice(quantity, price);
    else if (event == 'sub')
      calculateSubtractPrice(quantity, price);
    else if (event == 'delete') showDeleteDialog(quantity);
  }

  void calculateAddPrice(quantity, price) {
    double qnt = double.parse(quantity) - 1;
    double actualMulPrice = double.parse(quantity) * double.parse(price);
    double priceMinusQnt = qnt * double.parse(price);
    double prices = double.parse(grandTotalPrice.value) - priceMinusQnt;
    double totalPrices = prices + actualMulPrice;
    grandTotalPrice.value = totalPrices.toStringAsFixed(2);
  }

  void calculateSubtractPrice(quantity, price) {
    double qnt = double.parse(quantity) + 1;
    double actualMulPrice = double.parse(quantity) * double.parse(price);
    double priceMinusQnt = qnt * double.parse(price);
    double prices = double.parse(grandTotalPrice.value) - priceMinusQnt;
    double totalPrices = prices + actualMulPrice;
    grandTotalPrice.value = totalPrices.toStringAsFixed(2);
  }

  void grandTotal() {
    double totalPrice = 0;
    for (int i = 0; i < Common.cartModel.length; i++) {
      double price = double.parse(Common.cartModel[i].quantity!) * double.parse(Common.cartModel[i].newPrice!);
      totalPrice += price;
    }
    grandTotalPrice.value = totalPrice.toStringAsFixed(2);
  }

  void showDeleteDialog(String timeAdded) {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "deleteItem".tr,
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("no".tr),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          deleteFromCart(timeAdded);
        },
        child: Text("yes".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }

  deleteFromCart(String timeAdded) async {
    Query query = databaseReference.child('Cart').orderByChild('timeAdded').equalTo(timeAdded);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        var encoded = jsonEncode(snapshot.value);
        var decoded = jsonDecode(encoded);
        await databaseReference.child('Cart').child(decoded.keys.toString().replaceAll('(', '').replaceAll(')', '').toString()).remove();
        hasData.value = false;
        showCart();
        grandTotal();
      }
    });
  }
}
