import 'dart:convert';

import 'package:awesome_card/awesome_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/cards_model.dart';
import 'package:foodizm/screens/add_new_card_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String? origin;

  const PaymentMethodScreen({Key? key, this.origin}) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  Utils utils = new Utils();
  RxInt activeId = 0.obs;
  var databaseReference = FirebaseDatabase.instance.reference();
  RxList<CardsModel> userCardsList = <CardsModel>[].obs;
  RxBool hasData = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showUserCards();
  }

  showUserCards() async {
    userCardsList.clear();
    Query query = databaseReference.child('User_Credit_Card').child(utils.getUserId());
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          userCardsList.add(CardsModel.fromJson(Map.from(value)));
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
        title: utils.poppinsMediumText('paymentMethod1'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => AddNewCardScreen())!.then((value) {
                  showUserCards();
                });
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: utils.poppinsSemiBoldText('addNewCard'.tr, 14.0, AppColors.primaryColor, TextAlign.right),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (hasData.value) {
                  if (userCardsList.length > 0) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < userCardsList.length; i++)
                            Column(
                              children: [
                                if (widget.origin == 'choose')
                                  RadioListTile(
                                    value: i,
                                    groupValue: activeId.value,
                                    activeColor: AppColors.primaryColor,
                                    onChanged: (value) {
                                      activeId.value = int.parse(value.toString());
                                      Common.cardNumber = userCardsList[int.parse(value.toString())].cardNumber;
                                      Get.back();
                                    },
                                    title: utils.poppinsMediumText('useCard'.tr, 14.0, AppColors.primaryColor, TextAlign.left),
                                  ),
                                if (widget.origin == 'show') SizedBox(height: 10),
                                Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (widget.origin == 'choose') {
                                          activeId.value = i;
                                          Common.cardNumber = userCardsList[i].cardNumber;
                                          Get.back();
                                        }
                                      },
                                      child: CreditCard(
                                        cardNumber: hideCardNum(userCardsList[i].cardNumber!),
                                        cardExpiry: userCardsList[i].expiryDate,
                                        cardHolderName: userCardsList[i].cardHolderName,
                                        cvv: userCardsList[i].cvv,
                                        frontBackground: Container(width: double.maxFinite, height: double.maxFinite, color: AppColors.darkBlueColor),
                                        backBackground: CardBackgrounds.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDeleteDialog(userCardsList[i].cardNumber!);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 30),
                                        child: Image.asset('assets/images/delete.png', height: 50, width: 40),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                        ],
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
      ),
    );
  }

  hideCardNum(String number) {
    String result = "";
    result = number.substring(0, 4) + " **** **** " + number.substring(number.length - 4);
    return result;
  }

  void showDeleteDialog(String cardNumber) {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "deleteCard".tr,
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
          deleteCard(cardNumber);
        },
        child: Text("yes".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }

  deleteCard(String cardNumber) async {
    Query query = databaseReference.child('User_Credit_Card').child(utils.getUserId()).orderByChild('cardNumber').equalTo(cardNumber);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        var encoded = jsonEncode(snapshot.value);
        var decoded = jsonDecode(encoded);
        await databaseReference
            .child('User_Credit_Card')
            .child(utils.getUserId())
            .child(decoded.keys.toString().replaceAll('(', '').replaceAll(')', '').toString())
            .remove();
        hasData.value = false;
        showUserCards();
      }
    });
  }
}
