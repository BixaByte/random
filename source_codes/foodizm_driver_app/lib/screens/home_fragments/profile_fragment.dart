import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/models/driver_model.dart';
import 'package:foodizm_driver_app/screens/settings_screen.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:get/get.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  Rx<DriverModel> driverModel = new DriverModel().obs;
  RxBool hasData = false.obs;

  @override
  void initState() {
    super.initState();
    getDriverDetails();
  }

  getDriverDetails() async {
    await databaseReference.child('Drivers').child(utils.getUserId()).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        driverModel.value = DriverModel.fromJson(Map.from(dataSnapshot.value));
      }
      hasData.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(child: utils.helveticaBoldText('My Profile', 22.0, AppColors.blackColor, TextAlign.start)),
                InkWell(
                  onTap: () {
                    Get.to(() => SettingsScreen());
                  },
                  child: SvgPicture.asset('assets/images/gears.svg', height: 25, width: 25),
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (hasData.value) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30, bottom: 10),
                              child: Container(
                                decoration:
                                    new BoxDecoration(color: AppColors.whiteColor, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryColor)),
                                height: 125,
                                width: 125,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: driverModel.value.profileImage == null
                                      ? SvgPicture.asset('assets/images/man.svg')
                                      : driverModel.value.profileImage != 'default'
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: driverModel.value.profileImage!,
                                                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                ),
                                                errorWidget: (context, url, error) => SvgPicture.asset('assets/images/man.svg'),
                                              ),
                                            )
                                          : SvgPicture.asset('assets/images/man.svg'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          initialValue: driverModel.value.fullName != null && driverModel.value.fullName != 'default' ? driverModel.value.fullName : '',
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: utils.inputDecorationWithLabel('', 'Name', AppColors.whiteColor, AppColors.primaryColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          initialValue: driverModel.value.email != null && driverModel.value.email != 'default' ? driverModel.value.email : '',
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          decoration: utils.inputDecorationWithLabel('', 'Email', AppColors.whiteColor, AppColors.primaryColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          initialValue:
                              driverModel.value.phoneNumber != null && driverModel.value.phoneNumber != 'default' ? driverModel.value.phoneNumber : '',
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          decoration: utils.inputDecorationWithLabel('', 'Phone Number', AppColors.whiteColor, AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: Get.height,
                  child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
                );
              }
            }),
          )
        ],
      ),
    );
  }
}
