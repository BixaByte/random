import 'dart:math' as math;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/user_model.dart';
import 'package:foodizm/screens/enable_location_screen.dart';
import 'package:foodizm/screens/profile_creation_screens/otp_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  Utils utils = new Utils();
  FirebaseAuth auth = FirebaseAuth.instance;
  var databaseReference = FirebaseDatabase.instance.reference();
  var userNameController = new TextEditingController();
  var phoneNumberController = new TextEditingController();
  var emailController = new TextEditingController();
  var fullNameController = new TextEditingController();
  var dobController = new TextEditingController().obs;
  RxInt genderIndex = 3.obs;
  var formKey = GlobalKey<FormState>();
  RxBool emailReadOnly = false.obs;
  RxBool phoneReadOnly = false.obs;
  bool newValue = true;
  String phoneCode = "";
  String countryName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (auth.currentUser != null) {
      if (auth.currentUser!.email != null && auth.currentUser!.email!.isNotEmpty) {
        emailReadOnly.value = true;
        emailController.text = auth.currentUser!.email!;
      }

      if (auth.currentUser!.phoneNumber != null && auth.currentUser!.phoneNumber!.isNotEmpty) {
        phoneReadOnly.value = true;
        phoneNumberController.text = auth.currentUser!.phoneNumber!;
      } else {
        Common.verified.value = false;
      }
    } else {
      Common.verified.value = false;
    }
    getIpV4();
  }

  void getIpV4() async {
    final ipv4 = await Ipify.ipv4();
    final someGeo = await Ipify.geo('at_gQpjppVT8w04NPI7180cb80VUvYgr', ip: ipv4);
    countryName = someGeo.location!.country!;
    print(someGeo);
    print("IP : " + ipv4);
    setState(() {});
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
        title: utils.poppinsMediumText('2 of 2', 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: Obx(() {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  utils.poppinsSemiBoldText('completeYourProfile'.tr, 25.0, AppColors.primaryColor, TextAlign.center),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: userNameController,
                            keyboardType: TextInputType.text,
                            onChanged: checkUserName,
                            decoration: utils.inputDecorationWithLabel('userNameEg'.tr, 'userName'.tr, AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enterUserName".tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Obx(() => Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: utils.myBoxDecoration(Colors.transparent, AppColors.blackColor),
                                    child: countryName == ''
                                        ? Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: CupertinoActivityIndicator())
                                        : CountryCodePicker(
                                            enabled: newValue,
                                            onChanged: (value) {
                                              phoneCode = value.dialCode!;
                                            },
                                            onInit: (value) {
                                              phoneCode = value!.dialCode!;
                                            },
                                            initialSelection: countryName,
                                            showCountryOnly: false,
                                            showOnlyCountryWhenClosed: false,
                                            alignLeft: false,
                                          ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: phoneNumberController,
                                      readOnly: phoneReadOnly.value,
                                      onChanged: (value) {
                                        if (auth.currentUser!.phoneNumber != (phoneCode + value)) {
                                          Common.verified.value = false;
                                          newValue = true;
                                        } else if (auth.currentUser!.phoneNumber == (phoneCode + value)) {
                                          Common.verified.value = true;
                                          newValue = false;
                                        }
                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: utils.inputDecorationWithLabel('phoneEg'.tr, 'phoneNumber'.tr, AppColors.lightGrey2Color),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "enterPhone".tr;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Obx(() => InkWell(
                                        onTap: () {
                                          if (!Common.verified.value) {
                                            if (phoneNumberController.text.isNotEmpty)
                                              verifyNumber();
                                            else
                                              utils.showToast('enterPhone'.tr);
                                          } else {
                                            utils.showToast('phoneAlreadyVerified'.tr);
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Image.asset(
                                            'assets/images/correct.png',
                                            height: 30,
                                            width: 30,
                                            color: Common.verified.value ? AppColors.primaryColor : AppColors.lightGreyColor,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: utils.inputDecorationWithLabel('emailEg'.tr, 'email'.tr, AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enterEmail".tr;
                              }
                              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                return 'enterCorrectEmail'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            controller: fullNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: utils.inputDecorationWithLabel('fullNameEg'.tr, 'fullName'.tr, AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enterFullName".tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        utils.poppinsRegularText('chooseGender'.tr, 18.0, AppColors.primaryColor, TextAlign.center),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    genderIndex.value = 0;
                                  },
                                  child: Container(
                                    height: 100,
                                    child: buildBox(0, 'male'.tr, 'assets/images/male.svg'),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    genderIndex.value = 1;
                                  },
                                  child: Container(
                                    height: 100,
                                    child: buildBox(1, 'female'.tr, 'assets/images/female.svg'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            controller: dobController.value,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: AppColors.primaryColor,
                                        onPrimary: AppColors.whiteColor,
                                        surface: AppColors.whiteColor,
                                        onSurface: AppColors.primaryColor,
                                      ),
                                      dialogBackgroundColor: AppColors.whiteColor,
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              dobController.value.text = DateFormat("dd-MMM-yyyy").format(pickedDate!);
                            },
                            decoration: utils.inputDecorationWithLabel('dobEg'.tr, 'dob'.tr, AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "selectDob".tr;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (genderIndex.value != 3) {
                            if (Common.verified.value) {
                              checkUserNameBeforeUploading();
                            } else {
                              utils.showToast('verifyNumber'.tr);
                            }
                          } else {
                            utils.showToast('pleaseChooseGender'.tr);
                          }
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        child: Center(child: utils.poppinsMediumText('next'.tr, 16.0, AppColors.primaryColor, TextAlign.center)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  buildBox(index, text, icon) {
    return Card(
      color: genderIndex.value == index ? AppColors.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.primaryColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == 'female'.tr)
            Transform.rotate(
              angle: 90 * math.pi / 21,
              child: SvgPicture.asset(icon, height: 20, width: 20, color: genderIndex.value == index ? AppColors.whiteColor : AppColors.primaryColor),
            ),
          if (text == 'male'.tr)
            SvgPicture.asset(icon, height: 20, width: 20, color: genderIndex.value == index ? AppColors.whiteColor : AppColors.primaryColor),
          utils.poppinsRegularText(text, 18.0, genderIndex.value == index ? AppColors.whiteColor : AppColors.primaryColor, TextAlign.center)
        ],
      ),
    );
  }

  verifyNumber() async {
    utils.showLoadingDialog();

    print("number to verify: " + phoneCode + phoneNumberController.text);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneCode + phoneNumberController.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        Common.credential = credential;
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.back();
        utils.showToast(e.message.toString());
      },
      codeSent: (String? verificationId, int? resendToken) async {
        Common.codeSent = verificationId;
        Common.resendToken = resendToken;
        Get.back();
        await Get.to(() => OtpScreen(number: phoneCode + phoneNumberController.text, origin: 'second'));
        phoneNumberController.text = auth.currentUser!.phoneNumber!.substring(phoneCode.length);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  checkUserName(String value) async {
    Query query = databaseReference.child('UsersName').orderByChild('userName').equalTo(value);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        utils.showToast('userNameAlready'.tr);
      }
    });
  }

  checkUserNameBeforeUploading() async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('UsersName').orderByChild('userName').equalTo(userNameController.text);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        utils.showToast('userNameAlready'.tr);
      } else {
        Map<String, dynamic> value = {
          'userName': userNameController.text,
          'gender': genderIndex.value == 0 ? 'male'.tr : 'female'.tr,
          'date_of_birth': dobController.value.text,
          'fullName': fullNameController.text,
          'phoneNumber': auth.currentUser!.phoneNumber!,
          'email': emailController.text,
        };
        databaseReference.child('Users').child(Utils().getUserId()).update(value).whenComplete(() async {
          await databaseReference.child('UsersName').push().set({'userName': userNameController.text});
          saveUser(Utils().getUserId());
        }).onError((error, stackTrace) {
          Get.back();
          Utils().showToast(error.toString());
        });
      }
    });
  }

  saveUser(String uid) {
    Query query = databaseReference.child('Users').child(uid);
    query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Common.userModel = UserModel.fromJson(Map.from(snapshot.value));
        Utils().showToast('profileUpdated'.tr);
        Get.offAll(() => EnableLocationScreen());
      } else {
        Get.back();
        Utils().showToast('noUserFound'.tr);
      }
    });
  }
}
