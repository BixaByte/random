import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/restaurant_details_model.dart';
import 'package:foodizm_admin_app/screens/home_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Utils utils = new Utils();
  var emailController = new TextEditingController(text: 'admin@admin.com');
  var passwordController = new TextEditingController(text: '123456');
  RxBool _obscureText = true.obs;
  var formKey = GlobalKey<FormState>();
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Center(
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  utils.poppinsMediumText('Get started with login', 16.0, AppColors.primaryColor, TextAlign.start),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: utils.inputDecorationWithLabel('Email', 'Email', AppColors.whiteColor, AppColors.primaryColor),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Email";
                              }
                              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                return 'Please Enter Correct Email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Obx(() => Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: TextFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.text,
                                obscureText: _obscureText.value,
                                decoration: utils.inputDecorationWithLabel(
                                  'Password',
                                  'Password',
                                  AppColors.whiteColor,
                                  AppColors.primaryColor,
                                  image: _obscureText.value ? 'assets/images/view.svg' : 'assets/images/hide.svg',
                                  onTap: () {
                                    _obscureText.value = !_obscureText.value;
                                  },
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Password";
                                  }
                                  return null;
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    login();
                  }
                },
                child: Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Center(child: utils.poppinsMediumText('Login', 16.0, AppColors.whiteColor, TextAlign.center)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  login() async {
    utils.showLoadingDialog();
    await databaseReference.child('Admin').once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapValue = Map.from(snapshot.value);
        if (mapValue['email'].toString() != emailController.text) {
          Get.back();
          utils.showToast('Invalid Email');
        } else if (mapValue['password'].toString() != passwordController.text) {
          Get.back();
          utils.showToast('Invalid Password');
        } else {
          getRestaurantDetails();
        }
      } else {
        Get.back();
        utils.showToast('This Restaurant is not exist');
      }
    });
  }

  getRestaurantDetails() async {
    await Hive.openBox('credentials');
    final box = Hive.box('credentials');
    await databaseReference.child('RestaurantDetails').once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Common.restaurantDetails.value = RestaurantDetailsModel.fromJson(Map.from(snapshot.value));
        box.put('email', emailController.text);
        box.put('password', passwordController.text);
        Get.offAll(() => HomeScreen());
        utils.showToast('Login Successfully');
      } else {
        Get.back();
        utils.showToast('This Restaurant is not exist');
      }
    });
  }
}
