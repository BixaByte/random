import 'package:awesome_card/awesome_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  _AddNewCardScreenState createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  Utils utils = new Utils();
  RxString cardNumber = ''.obs;
  RxString cardHolderName = ''.obs;
  Rx<MaskedTextController> expiryDate = new MaskedTextController(mask: '00/00').obs;
  RxString cvv = ''.obs;
  RxBool showBack = false.obs;
  var formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      _focusNode.hasFocus ? showBack.value = true : showBack.value = false;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
        title: utils.poppinsMediumText('addNewCard'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                CreditCard(
                  cardNumber: cardNumber.value,
                  cardExpiry: expiryDate.value.text,
                  cardHolderName: cardHolderName.value,
                  cvv: cvv.value,
                  showBackSide: showBack.value,
                  frontBackground: Container(width: double.maxFinite, height: double.maxFinite, color: AppColors.darkBlueColor),
                  backBackground: CardBackgrounds.white,
                ),
                SizedBox(height: 40),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          decoration: utils.inputDecorationWithLabel('cardNumber'.tr, 'cardNumber'.tr, AppColors.primaryColor),
                          maxLength: 19,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            cardNumber.value = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enterCardNumber'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TextFormField(
                          controller: expiryDate.value,
                          decoration: utils.inputDecorationWithLabel('cardExpiry'.tr, 'cardExpiry'.tr, AppColors.primaryColor),
                          maxLength: 5,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              expiryDate.value.text = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enterCardExpiry'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TextFormField(
                          decoration: utils.inputDecorationWithLabel('cardHolderName'.tr, 'cardHolderName'.tr, AppColors.primaryColor),
                          textCapitalization: TextCapitalization.words,
                          onChanged: (value) {
                            cardHolderName.value = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enterCardHolderName'.tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TextFormField(
                          decoration: utils.inputDecorationWithLabel('cvv'.tr, 'cvv'.tr, AppColors.primaryColor),
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            cvv.value = value;
                          },
                          focusNode: _focusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enterCvv'.tr;
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
                      checkCardNumberBeforeUploading();
                    }
                  },
                  child: Container(
                    height: 40,
                    width: Get.width,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
            )),
      ),
    );
  }

  checkCardNumberBeforeUploading() async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('User_Credit_Card').child(utils.getUserId()).orderByChild('cardNumber').equalTo(cardNumber.value);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Get.back();
        utils.showToast('cardNumberAlready'.tr);
      } else {
        addCard();
      }
    });
  }

  addCard() {
    databaseReference.child('User_Credit_Card').child(utils.getUserId()).push().set({
      'cardHolderName': cardHolderName.value,
      'cardNumber': cardNumber.value,
      'expiryDate': expiryDate.value.text,
      'cvv': cvv.value,
      'status': 'Standard',
    }).whenComplete(() {
      Get.back();
      Get.back();
      utils.showToast('cardAdded'.tr);
    }).onError((error, stackTrace) {
      Get.back();
      print(error.toString());
      utils.showToast(error.toString());
    });
  }
}
