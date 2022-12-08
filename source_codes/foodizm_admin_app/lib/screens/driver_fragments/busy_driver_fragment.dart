import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/driver_model.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/database_model/user_model.dart';
import 'package:foodizm_admin_app/utils/send_notification_interface.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/driver_widget.dart';
import 'package:get/get.dart';

class BusyDriverFragment extends StatefulWidget {
  final OrderModel? orderModel;

  const BusyDriverFragment({Key? key, this.orderModel}) : super(key: key);

  @override
  _BusyDriverFragmentState createState() => _BusyDriverFragmentState();
}

class _BusyDriverFragmentState extends State<BusyDriverFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;

  @override
  void initState() {
    super.initState();
    showBusyDrivers();
  }

  showBusyDrivers() async {
    Common.busyDriverModel.clear();
    Query query = databaseReference.child('Drivers').orderByChild('onlineStatus').equalTo('busy');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.busyDriverModel.add(DriverModel.fromJson(Map.from(value)));
        });
      }
      hasData.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (hasData.value) {
        if (Common.busyDriverModel.length > 0) {
          return SingleChildScrollView(
            child: Column(children: [
              for (int i = 0; i < Common.busyDriverModel.length; i++)
                DriverWidget(
                  driverModel: Common.busyDriverModel[i],
                  function: (DriverModel driverModel) {
                    assignDriver(driverModel);
                  },
                )
            ]),
          );
        } else {
          return utils.noDataWidget('noDriverFound'.tr, Get.height);
        }
      } else {
        return Container(
          height: Get.height,
          child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
        );
      }
    });
  }

  assignDriver(DriverModel driverModel) async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(widget.orderModel!.orderId);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).update({
            'timeOnTheWay': DateTime.now().millisecondsSinceEpoch.toString(),
            'status': 'onTheWay',
            'driverUid': driverModel.uid!,
          });
          changeBusyStatus(driverModel);
        });
      }
    });
  }

  changeBusyStatus(DriverModel driverModel) async {
    Query query = databaseReference.child('Drivers').child(driverModel.uid!);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        await databaseReference.child('Drivers').child(driverModel.uid!).update({'onlineStatus': 'busy'});
        Get.back();
        Get.back();
        utils.showToast("orderAssign".tr);
        getUserToken(widget.orderModel!, 'orderOnTheWayTitle'.tr);
      }
    });
  }

  getUserToken(OrderModel orderModel, String title) async {
    await databaseReference.child('Users').child(orderModel.uid!).once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        UserModel userModel = UserModel.fromJson(Map.from(snapshot.value));
        if (userModel.userToken != null) {
          String body = 'trackOrderBody'.tr + ' ' + orderModel.orderId!;
          SendNotificationInterface().sendNotification(title, body, userModel.userToken!, 'Order');
        }
      }
    });
  }
}
