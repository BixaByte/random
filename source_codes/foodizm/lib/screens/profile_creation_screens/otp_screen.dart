import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/user_model.dart';
import 'package:foodizm/screens/enable_location_screen.dart';
import 'package:foodizm/screens/home_screen.dart';
import 'package:foodizm/screens/profile_creation_screens/add_photo_screen.dart';
import 'package:foodizm/screens/profile_creation_screens/complete_profile_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OtpScreen extends StatefulWidget {
  final String? number, origin;

  OtpScreen({Key? key, this.number, this.origin}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Utils utils = new Utils();
  String currentText = "";
  RxBool otpVerified = true.obs;
  RxBool sendAgain = false.obs;
  RxBool hasError = false.obs;
  late StreamController<ErrorAnimationType> errorController;
  final CountdownController _controller = new CountdownController(autoStart: true);
  final otpController = TextEditingController();
  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Obx(() {
        return SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: Image(
                      image: AssetImage('assets/images/img_2.png'),
                      alignment: Alignment.topCenter,
                      height: Get.height,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(flex: 3, child: SizedBox())
                ],
              ),
              Column(
                children: [
                  Expanded(flex: 3, child: SizedBox()),
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                      width: Get.width,
                      child: Card(
                        color: AppColors.whiteColor,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/smartphone.svg',
                                  color: AppColors.primaryColor,
                                  height: 40,
                                  width: 40,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: utils.helveticaBoldText('validationCode'.tr, 20.0, AppColors.primaryColor, TextAlign.center),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: utils.poppinsRegularText(
                                      'otpSentTo'.tr + ' ' + widget.number!, 16.0, AppColors.lightGrey2Color, TextAlign.center),
                                ),
                                Obx(() => Container(
                                      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                                      child: PinCodeTextField(
                                        appContext: context,
                                        pastedTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        length: 6,
                                        blinkWhenObscuring: true,
                                        animationType: AnimationType.fade,
                                        pinTheme: PinTheme(
                                          disabledColor: Colors.red,
                                          inactiveColor: Colors.grey,
                                          selectedColor: AppColors.primaryColor,
                                          shape: PinCodeFieldShape.underline,
                                          fieldHeight: 40,
                                          fieldWidth: 40,
                                          activeFillColor: hasError.value ? Colors.blue.shade100 : Colors.white,
                                        ),
                                        cursorColor: Colors.black,
                                        animationDuration: Duration(milliseconds: 300),
                                        errorAnimationController: errorController,
                                        controller: otpController,
                                        keyboardType: TextInputType.number,
                                        boxShadows: [],
                                        onCompleted: (v) {
                                          print("Completed");
                                        },
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            currentText = value;
                                          });
                                        },
                                        beforeTextPaste: (text) {
                                          print("Allowing to paste $text");
                                          return true;
                                        },
                                      ),
                                    )),
                                InkWell(
                                  onTap: () {
                                    verifyNumber();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        utils.poppinsRegularText('notGetCode'.tr + ' ', 14.0, AppColors.lightGrey2Color, TextAlign.center),
                                        utils.poppinsRegularText('resend'.tr + ' ', 14.0,
                                            sendAgain.value ? AppColors.primaryColor : AppColors.lightGrey2Color, TextAlign.center),
                                        Countdown(
                                          controller: _controller,
                                          seconds: 30,
                                          build: (BuildContext context, double time) =>
                                              utils.poppinsRegularText(time.toString(), 14.0, AppColors.primaryColor, TextAlign.center),
                                          interval: Duration(seconds: 1),
                                          onFinished: () {
                                            setState(() {
                                              sendAgain.value = true;
                                              _controller.restart();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (currentText.length != 6) {
                                      errorController.add(ErrorAnimationType.shake);
                                      setState(() {
                                        hasError.value = true;
                                      });
                                    } else {
                                      if (widget.origin == 'first') {
                                        verifyOTP();
                                      } else {
                                        attachPhoneNumber();
                                      }
                                    }
                                  },
                                  child: makeButton(AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  makeButton(color) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: Center(child: utils.poppinsMediumText('verify'.tr, 16.0, color, TextAlign.center)),
    );
  }

  verifyNumber() async {
    utils.showLoadingDialog();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.number!,
      verificationCompleted: (PhoneAuthCredential credential) {
        Common.credential = credential;
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.back();
        utils.showToast(e.message.toString());
        print(e.message.toString());
      },
      codeSent: (String? verificationId, int? resendToken) {
        Common.codeSent = verificationId;
        Common.resendToken = resendToken;
        Get.back();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    utils.showLoadingDialog();
    FirebaseAuth auth = FirebaseAuth.instance;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: Common.codeSent!, smsCode: currentText);

    await auth.signInWithCredential(credential).whenComplete(() {
      if (auth.currentUser != null) {
        Common.verified.value = true;
        checkUser(auth.currentUser!.uid, auth.currentUser!.phoneNumber!);
      } else {
        Get.back();
        hasError.value = true;
        utils.showToast('enterOtp'.tr);
      }
    });
  }

  void attachPhoneNumber() async {
    utils.showLoadingDialog();
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: Common.codeSent!, smsCode: currentText);

    await auth.currentUser!.updatePhoneNumber(credential).whenComplete(() {
      if (auth.currentUser != null) {
        Common.verified.value = true;
        Get.back();
        Get.back();
      } else {
        Get.back();
        hasError.value = true;
        utils.showToast('enterOtp'.tr);
      }
    });
  }

  checkUser(String uid, String phoneNumber) async {
    await Hive.openBox('credentials');
    final box = Hive.box('credentials');
    var status = await Permission.location.status;
    databaseReference.child('Users').child(uid).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        box.put('uid', uid);
        Common.userModel = UserModel.fromJson(Map.from(dataSnapshot.value));
        if (Common.userModel.profilePicture == 'default') {
          Get.offAll(() => AddPhotoScreen());
        } else if (Common.userModel.userName == 'default') {
          Get.offAll(() => CompleteProfileScreen());
        } else {
          if (status == PermissionStatus.granted) {
            utils.getUserCurrentLocation('');
            Get.offAll(() => HomeScreen());
          } else {
            Get.offAll(() => EnableLocationScreen());
          }
        }
      } else {
        box.put('uid', uid);
        createUser(uid, phoneNumber);
      }
    });
  }

  createUser(String uid, String phoneNumber) {
    databaseReference.child('Users').child(uid).set({
      'uid': uid,
      'email': 'default',
      'fullName': 'default',
      'profilePicture': 'default',
      'userName': 'default',
      'phoneNumber': phoneNumber,
      'gender': 'default',
      'date_of_birth': 'default',
    }).whenComplete(() {
      Get.offAll(() => AddPhotoScreen());
    }).onError((error, stackTrace) {
      Get.back();
      print(error.toString());
      utils.showToast(error.toString());
    });
  }
}
