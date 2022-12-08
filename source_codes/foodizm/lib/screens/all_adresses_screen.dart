import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/addresses_model.dart';
import 'package:foodizm/screens/add_new_address_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class AllAddressesScreen extends StatefulWidget {
  final String? origin;

  const AllAddressesScreen({Key? key, this.origin}) : super(key: key);

  @override
  _AllAddressesScreenState createState() => _AllAddressesScreenState();
}

class _AllAddressesScreenState extends State<AllAddressesScreen> {
  Utils utils = new Utils();
  RxInt activeId = 0.obs;
  var databaseReference = FirebaseDatabase.instance.reference();
  RxList<AddressesModel> addressesList = <AddressesModel>[].obs;
  RxBool hasData = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showUserAddress();
  }

  showUserAddress() async {
    addressesList.clear();
    Query query = databaseReference.child('User_Address').child(utils.getUserId());
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          addressesList.add(AddressesModel.fromJson(Map.from(value)));
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
        title: utils.poppinsMediumText('allAddresses'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => AddNewAddressScreen())!.then((value) {
                  showUserAddress();
                });
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5, bottom: 20),
                  child: utils.poppinsSemiBoldText('addNewAddress'.tr, 14.0, AppColors.primaryColor, TextAlign.right),
                ),
              ),
            ),
            Expanded(child: Obx(() {
              if (hasData.value) {
                if (addressesList.length > 0) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < addressesList.length; i++) showAddress(addressesList[i], i),
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
            }))
          ],
        ),
      ),
    );
  }

  showAddress(AddressesModel? addressesModel, int index) {
    return InkWell(
      onTap: () {
        if (widget.origin == 'choose') {
          activeId.value = index;
          Common.selectedAddress = addressesModel!.address!;
          Common.selectedLat = addressesModel.lat!;
          Common.selectedLng = addressesModel.lng!;
          Get.back();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Card(
          elevation: 2,
          shadowColor: AppColors.paymentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.origin == 'choose')
                Container(
                  width: 50,
                  child: Radio(
                    value: index,
                    groupValue: activeId.value,
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      activeId.value = int.parse(value.toString());
                      Common.selectedAddress = addressesModel!.address!;
                      Common.selectedLat = addressesModel.lat!;
                      Common.selectedLng = addressesModel.lng!;
                      Get.back();
                    },
                  ),
                ),
              if (widget.origin == 'show') SizedBox(width: 20),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: utils.poppinsSemiBoldText("title".tr + " : " + addressesModel!.title!, 14.0, AppColors.blackColor, TextAlign.start),
                          ),
                          Text(
                            "address".tr + " : " + addressesModel.address!,
                            style: TextStyle(
                              height: 1.1,
                              color: AppColors.blackColor,
                              fontSize: 14.0,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: utils.poppinsMediumText("zipCode".tr + " : " + addressesModel.zipCode!, 12.0, AppColors.blackColor, TextAlign.start),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          showDeleteDialog(addressesModel.address!);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 30, top: 10),
                          child: Image.asset('assets/images/delete.png', height: 50, width: 40),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(String cardNumber) {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "deleteAddress".tr,
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

  deleteCard(String address) async {
    Query query = databaseReference.child('User_Address').child(utils.getUserId()).orderByChild('address').equalTo(address);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('User_Address').child(utils.getUserId()).child(value).remove();
        });
        hasData.value = false;
        showUserAddress();
      }
    });
  }
}
