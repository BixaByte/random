import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/charges_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';

class DeliveryChargesScreen extends StatefulWidget {
  const DeliveryChargesScreen({Key? key}) : super(key: key);

  @override
  _DeliveryChargesScreenState createState() => _DeliveryChargesScreenState();
}

class _DeliveryChargesScreenState extends State<DeliveryChargesScreen> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  var chargesController = new TextEditingController();
  var freeDeliveryController = new TextEditingController();
  var maxRadiusController = new TextEditingController();
  var taxesController = new TextEditingController();
  RxBool hasData = false.obs;
  RxBool isLoading = true.obs;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getDeliveryCharges();
  }

  getDeliveryCharges() {
    Query query = databaseReference.child('Charges');
    query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Common.chargesModel.value = ChargesModel.fromJson(Map.from(snapshot.value));
        chargesController.text = Common.chargesModel.value.deliveryFeePerKm!;
        freeDeliveryController.text = Common.chargesModel.value.freeDeliveryRadius!;
        maxRadiusController.text = Common.chargesModel.value.maxRadius!;
        taxesController.text = Common.chargesModel.value.taxes!;
        hasData.value = true;
      }

      isLoading.value = false;
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
        title: utils.poppinsMediumText('deliveryChargesHeading'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Obx(() {
            if (!isLoading.value) {
              if (hasData.value) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      utils.poppinsSemiBoldText('editDeliveryCharges'.tr, 20.0, AppColors.primaryColor, TextAlign.center),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: chargesController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    utils.inputDecorationWithLabel('chargesFeePerKm'.tr, 'charges'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enterChargesFee'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: freeDeliveryController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    utils.inputDecorationWithLabel('freeDeliveryRadius'.tr, 'radius'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enterDeliveryRadius'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: maxRadiusController,
                                keyboardType: TextInputType.number,
                                decoration: utils.inputDecorationWithLabel('maxRadius'.tr, 'maxRadius'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Max Radius';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: taxesController,
                                keyboardType: TextInputType.number,
                                decoration: utils.inputDecorationWithLabel('taxesAvg'.tr, 'taxes'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'enterTaxes'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            utils.showLoadingDialog();
                            uploadData();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            border: Border.all(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: Center(child: utils.poppinsMediumText('update'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return utils.noDataWidget('noData'.tr, Get.height);
              }
            } else {
              return Container(
                height: Get.height,
                child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
              );
            }
          }),
        ),
      ),
    );
  }

  uploadData() async {
    Map<String, dynamic> value = {
      'deliveryFeePerKm': double.parse(chargesController.text),
      'freeDeliveryRadius': double.parse(freeDeliveryController.text),
      'maxRadius': double.parse(maxRadiusController.text),
      'taxes': double.parse(taxesController.text),
    };
    databaseReference.child('Charges').update(value).whenComplete(() async {
      Get.back();
      Get.back();
      Utils().showToast('dataUpdated'.tr);
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }
}
