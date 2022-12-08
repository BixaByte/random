import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/screens/select_location_on_map_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({Key? key}) : super(key: key);

  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  Utils utils = new Utils();
  var formKey = GlobalKey<FormState>();
  var titleController = new TextEditingController();
  var addressController = new TextEditingController();
  var zipCodeController = new TextEditingController();
  String? lat;
  String? lng;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('addNewAddress'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: titleController,
                        textCapitalization: TextCapitalization.words,
                        decoration: utils.inputDecorationWithLabel('title'.tr, 'title'.tr, AppColors.lightGrey2Color),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enterTitle'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: addressController,
                        minLines: 1,
                        maxLines: 5,
                        readOnly: true,
                        onTap: selectLocationOnMap,
                        decoration: utils.inputDecorationWithLabel('selectLocation'.tr, 'address'.tr, AppColors.lightGrey2Color),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'selectAddress'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: zipCodeController,
                        keyboardType: TextInputType.number,
                        decoration: utils.inputDecorationWithLabel('zipCode'.tr, 'zipCode'.tr, AppColors.lightGrey2Color),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enterZipCode'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    addAddress();
                  }
                },
                child: Container(
                  height: 40,
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  child: Center(child: utils.poppinsMediumText('submit'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectLocationOnMap() async {
    var result = await Get.to(() => SelectLocationOnMapScreen());
    if (result != null) {
      addressController.text = result[0];
      lat = result[1];
      lng = result[2];
      zipCodeController.text = result[4];
      print("Selected " + result.toString());
    }
    setState(() {});
  }

  addAddress() {
    utils.showLoadingDialog();
    databaseReference.child('User_Address').child(utils.getUserId()).push().set({
      'title': titleController.text,
      'address': addressController.text.trim(),
      'zipCode': zipCodeController.text,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'status': 'Standard',
    }).whenComplete(() {
      Get.back();
      Get.back();
      utils.showToast('addressAdded'.tr);
    }).onError((error, stackTrace) {
      Get.back();
      print(error.toString());
      utils.showToast(error.toString());
    });
  }
}
