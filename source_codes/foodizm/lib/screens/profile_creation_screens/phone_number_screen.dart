import 'package:country_code_picker/country_code_picker.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/screens/profile_creation_screens/otp_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  Utils utils = new Utils();
  String phoneCode = "";
  String countryName = "";
  final myController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Image(
                    image: AssetImage('assets/images/img_1.png'),
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
                                child: utils.helveticaBoldText('login'.tr, 20.0, AppColors.primaryColor, TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 15, right: 15),
                                child: utils.poppinsRegularText('validPhoneNumber'.tr, 16.0, AppColors.lightGrey2Color, TextAlign.center),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey4Color,
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      countryName == ''
                                          ? Padding(padding: EdgeInsets.only(left: 20), child: CupertinoActivityIndicator())
                                          : CountryCodePicker(
                                              onChanged: (value) {
                                                phoneCode = value.dialCode!;
                                                print(value.dialCode);
                                              },
                                              onInit: (value) {
                                                phoneCode = value!.dialCode!;
                                                print(value.dialCode);
                                              },
                                              initialSelection: countryName,
                                              showCountryOnly: false,
                                              showOnlyCountryWhenClosed: false,
                                              alignLeft: false,
                                            ),
                                      Expanded(
                                        flex: 8,
                                        child: TextField(
                                          controller: myController,
                                          keyboardType: TextInputType.number,
                                          decoration: utils.inputDecoration('enterPhoneNumber'.tr),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (myController.text.isNotEmpty) {
                                    verifyNumber();
                                  } else {
                                    utils.showToast('enterPhone'.tr);
                                  }
                                },
                                child: makeButton(AppColors.primaryColor),
                              )
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
      ),
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
      child: Center(child: utils.poppinsMediumText('send'.tr, 16.0, color, TextAlign.center)),
    );
  }

  verifyNumber() async {
    utils.showLoadingDialog();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneCode + myController.text,
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
        Get.to(() => OtpScreen(number: phoneCode + myController.text, origin: 'first'));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
