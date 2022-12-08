import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/screens/all_adresses_screen.dart';
import 'package:foodizm/screens/edit_profile_screen.dart';
import 'package:foodizm/screens/payment_method_screen.dart';
import 'package:foodizm/screens/welcome_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/not_login_widget.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    utils.getUserId() == null
                        ? Image(
                            image: AssetImage('assets/images/male_place.png'),
                            fit: BoxFit.cover,
                            width: Get.width,
                            alignment: Alignment.topCenter,
                          )
                        : Common.userModel.profilePicture != 'default'
                            ? Image(
                                image: NetworkImage(Common.userModel.profilePicture!),
                                fit: BoxFit.cover,
                                width: Get.width,
                                alignment: Alignment.topCenter,
                              )
                            : Image(
                                image: AssetImage('assets/images/male_place.png'),
                                fit: BoxFit.cover,
                                width: Get.width,
                                alignment: Alignment.topCenter,
                              ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(1, 1),
                          end: Alignment(1, 1),
                          colors: [Colors.transparent, AppColors.primaryColor.withAlpha(120)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 6, child: SizedBox())
            ],
          ),
          Column(
            children: [
              Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 3,
                child: Container(
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    elevation: 1,
                    shadowColor: AppColors.whiteColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: utils.poppinsMediumText(
                              utils.getUserId() == null
                                  ? 'fullName'.tr
                                  : Common.userModel.fullName != 'default'
                                      ? Common.userModel.fullName
                                      : 'fullName'.tr,
                              16.0,
                              AppColors.blackColor,
                              TextAlign.center),
                        ),
                        utils.poppinsMediumText(
                            utils.getUserId() == null
                                ? 'phoneNumber'.tr
                                : Common.userModel.phoneNumber != 'default'
                                    ? Common.userModel.phoneNumber
                                    : 'phoneNumber'.tr,
                            16.0,
                            AppColors.blackColor,
                            TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (utils.getUserId() == null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => NotLoginWidget('Dialog'),
                                  );
                                } else {
                                  Get.to(() => PaymentMethodScreen(origin: 'show'));
                                }
                              },
                              child: buildWidget('payment.svg', 'cards'.tr),
                            ),
                            InkWell(
                              onTap: () {
                                if (utils.getUserId() == null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => NotLoginWidget('Dialog'),
                                  );
                                } else {
                                  Get.to(() => AllAddressesScreen(origin: 'show'));
                                }
                              },
                              child: buildWidget('all_address.svg', 'allAddress'.tr),
                            ),
                            InkWell(
                              onTap: () {
                                if (utils.getUserId() == null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => NotLoginWidget('Dialog'),
                                  );
                                } else {
                                  Get.to(() => EditProfileScreen());
                                }
                              },
                              child: buildWidget('general_settings.svg', 'profileSettings'.tr),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: _launchWhatsapp,
                              child: buildWidget('gears.svg', 'settings'.tr),
                            ),
                            buildWidget('support.svg', 'support'.tr),
                            InkWell(
                              onTap: () {
                                if (utils.getUserId() == null) {
                                  Get.to(() => WelcomeScreen());
                                } else {
                                  showLogoutDialog();
                                }
                              },
                              child: buildWidget('logout.svg', utils.getUserId() == null ? 'login'.tr : 'logout'.tr),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              )
            ],
          ),
          Column(
            children: [
              Expanded(flex: 2, child: SizedBox()),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: new BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: utils.getUserId() == null
                        ? SvgPicture.asset("assets/images/man.svg", fit: BoxFit.cover)
                        : Common.userModel.profilePicture != 'default'
                            ? CachedNetworkImage(
                                imageUrl: Common.userModel.profilePicture!,
                                placeholder: (context, url) => Container(
                                  height: 30,
                                  width: 30,
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => SvgPicture.asset("assets/images/man.svg", fit: BoxFit.cover),
                              )
                            : SvgPicture.asset("assets/images/man.svg", fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(flex: 6, child: SizedBox())
            ],
          ),
        ],
      ),
    );
  }

  _launchWhatsapp() async {
    const url = "whatsapp://send?phone=+923028997122";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      utils.showToast("There is no whatsapp installed on your mobile");
    }
  }

  buildWidget(image, title) {
    return Container(
      width: Get.width / 3.3,
      child: Card(
        elevation: 1,
        shadowColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/$image', height: 25, width: 25),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: utils.poppinsRegularText(title, 14.0, AppColors.blackColor, TextAlign.center),
            )
          ],
        ),
      ),
    );
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "wantLogout".tr,
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
          Hive.box('credentials').deleteFromDisk();
          Get.back();
          Get.offAll(() => WelcomeScreen());
        },
        child: Text("yes".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }
}
