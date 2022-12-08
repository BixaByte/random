import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/user_model.dart';
import 'package:foodizm/screens/enable_location_screen.dart';
import 'package:foodizm/screens/home_screen.dart';
import 'package:foodizm/screens/profile_creation_screens/add_photo_screen.dart';
import 'package:foodizm/screens/profile_creation_screens/complete_profile_screen.dart';
import 'package:foodizm/screens/profile_creation_screens/phone_number_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Utils utils = new Utils();
  final databaseReference = FirebaseDatabase.instance.reference();

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
                    image: AssetImage('assets/images/welcome_img.png'),
                    alignment: Alignment.topCenter,
                    height: Get.height,
                    width: Get.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(flex: 3, child: SizedBox())
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.offAll(() => HomeScreen());
                },
                child: Container(
                  height: 40,
                  width: 100,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: utils.gradient(AppColors.primaryColor, AppColors.primaryColor, 25.0),
                  child: Center(
                    child: utils.poppinsSemiBoldText('skip'.tr, 15.0, AppColors.whiteColor, TextAlign.center),
                  ),
                ),
              ),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/account.svg',
                              height: 40,
                              width: 40,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: utils.helveticaBoldText('welcomeToFoodizm'.tr, 20.0, AppColors.primaryColor, TextAlign.center),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => PhoneNumberScreen());
                              },
                              child: makeButton(AppColors.phoneNoColor, 'phoneNumber'.tr, 'assets/images/phone.svg'),
                            ),
                            InkWell(
                              onTap: () async {
                                await signInWithFacebook();
                                if (FirebaseAuth.instance.currentUser != null) {
                                  if (FirebaseAuth.instance.currentUser!.email != null) {
                                    checkUser(FirebaseAuth.instance.currentUser!.uid, FirebaseAuth.instance.currentUser!.email!);
                                  } else {
                                    Get.back();
                                  }
                                } else {
                                  Get.back();
                                }
                              },
                              child: makeButton(AppColors.fbColor, 'facebook'.tr, 'assets/images/fb.svg'),
                            ),
                            InkWell(
                              onTap: () async {
                                await signInWithGoogle();
                                if (FirebaseAuth.instance.currentUser != null) {
                                  if (FirebaseAuth.instance.currentUser!.email != null) {
                                    checkUser(FirebaseAuth.instance.currentUser!.uid, FirebaseAuth.instance.currentUser!.email!);
                                  } else {
                                    Get.back();
                                  }
                                } else {
                                  Get.back();
                                }
                              },
                              child: makeButton(AppColors.googleColor, 'google'.tr, 'assets/images/google.svg'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  makeButton(color, text, icon) {
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
      child: Row(
        children: [
          Expanded(flex: 1, child: SizedBox()),
          Expanded(flex: 2, child: utils.poppinsMediumText(text, 16.0, color, TextAlign.center)),
          Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: SvgPicture.asset(icon))),
        ],
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    utils.showLoadingDialog();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth!.accessToken!, idToken: googleAuth.idToken!);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    utils.showLoadingDialog();
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  checkUser(String uid, String email) async  {
    await Hive.openBox('credentials');
    var status = await Permission.location.status;
    final box = Hive.box('credentials');
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
        createUser(uid, email);
      }
    }).onError((error, stackTrace) {
      print(error.toString());
      utils.showToast(error.toString());
    });
  }

  createUser(String uid, String email) {
    databaseReference.child('Users').child(uid).set({
      'uid': uid,
      'email': email,
      'fullName': 'default',
      'profilePicture': 'default',
      'userName': 'default',
      'phoneNumber': 'default',
      'gender': 'default',
      'date_of_birth': 'default',
    }).whenComplete(() {
      Get.offAll(() => AddPhotoScreen());
    }).onError((error, stackTrace) {
      print(error.toString());
      utils.showToast(error.toString());
    });
  }
}
