import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/database_model/user_model.dart';
import 'package:foodizm_admin_app/utils/send_notification_interface.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';

class NotifyCustomerFragment extends StatefulWidget {
  const NotifyCustomerFragment({Key? key}) : super(key: key);

  @override
  _NotifyCustomerFragmentState createState() => _NotifyCustomerFragmentState();
}

class _NotifyCustomerFragmentState extends State<NotifyCustomerFragment> {
  Utils utils = new Utils();
  var titleController = new TextEditingController();
  var messageController = new TextEditingController();
  var databaseReference = FirebaseDatabase.instance.reference();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utils.helveticaBoldText('notifyCustomer'.tr, 22.0, AppColors.blackColor, TextAlign.start),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: titleController,
                      textCapitalization: TextCapitalization.words,
                      decoration: utils.inputDecorationWithLabel('enterTitle'.tr, 'title'.tr, AppColors.whiteColor, AppColors.primaryColor),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "pleaseEnterTitle".tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextFormField(
                      controller: messageController,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 10,
                      decoration: utils.inputDecorationWithLabel('enterMessage'.tr, 'message'.tr, AppColors.whiteColor, AppColors.primaryColor),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "pleaseEnterMessage".tr;
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
                  getAllUsers();
                }
              },
              child: Container(
                height: 45,
                margin: EdgeInsets.symmetric(vertical: 30),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Center(child: utils.poppinsMediumText('send'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> userTokens = [];

  getAllUsers() async {
    await databaseReference.child('Users').once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) async {
          UserModel userModel = UserModel.fromJson(Map.from(value));
          if (userModel.userToken != null) {
            userTokens.add(userModel.userToken!);
          }
        });
        sendNotifications(userTokens, '0');
      } else {
        utils.showToast('noUserFound'.tr);
      }
    });
  }

  sendNotifications(List<String> userTokens, String no) async {
    if (no == '0') utils.showLoadingDialog();
    if (userTokens.length > 0) {
      await SendNotificationInterface().sendNotification(titleController.text, messageController.text, userTokens[0], 'New Message');
      userTokens.removeAt(0);
      sendNotifications(userTokens, '1');
    } else {
      titleController.text = '';
      messageController.text = '';
      Get.back();
      utils.showToast('notificationSent'.tr);
    }
  }
}
