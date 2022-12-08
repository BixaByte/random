import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/database_model/user_model.dart';
import 'package:foodizm_admin_app/utils/send_notification_interface.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/order_widget.dart';
import 'package:get/get.dart';

class PendingOrdersFragment extends StatefulWidget {
  const PendingOrdersFragment({Key? key}) : super(key: key);

  @override
  _PendingOrdersFragmentState createState() => _PendingOrdersFragmentState();
}

class _PendingOrdersFragmentState extends State<PendingOrdersFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;

  late StreamSubscription<Event> orderUpdate;
  late StreamSubscription<Event> orderAdded;
  late StreamSubscription<Event> orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.pendingOrderModel.clear();
    showPendingOrders();
  }

  showPendingOrders() async {
    orderAdded = databaseReference.child('Orders').orderByChild('status').equalTo('requested').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.pendingOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value)));
      }
    });

    orderRemoved = databaseReference.child('Orders').orderByChild('status').equalTo('requested').onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        Common.pendingOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Orders').orderByChild('status').equalTo('requested').onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        var index = Common.pendingOrderModel.indexWhere((item) => item.orderId == list.orderId);
        Common.pendingOrderModel[index] = list;
      }
    });

    hasData.value = true;
  }

  @override
  void dispose() {
    orderAdded.cancel();
    orderUpdate.cancel();
    orderRemoved.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (hasData.value) {
        if (Common.pendingOrderModel.length > 0) {
          return SingleChildScrollView(
            child: Column(children: [
              for (int i = 0; i < Common.pendingOrderModel.length; i++)
                OrderWidget(
                  status: 'Pending',
                  orderModel: Common.pendingOrderModel[i],
                  function: (String status, OrderModel orderModel) {
                    if (status == 'accepted') {
                      changeOrderStatus(status, orderModel);
                    } else if (status == 'rejected') {
                      addToCancelledOrder(status, orderModel);
                    }
                  },
                )
            ]),
          );
        } else {
          return utils.noDataWidget('noOrders'.tr, Get.height);
        }
      } else {
        return Container(
          height: Get.height,
          child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
        );
      }
    });
  }

  changeOrderStatus(String status, OrderModel orderModel) async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).update({
            'timeAccepted': DateTime.now().millisecondsSinceEpoch.toString(),
            'status': status,
          });
          Get.back();
          utils.showToast("orderAccepted".tr);
          getUserToken(orderModel, 'orderAcceptedTitle'.tr);
        });
      }
    });
  }

  addToCancelledOrder(String status, OrderModel orderModel) async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).update({'status': status});
          await databaseReference.child('Cancelled_Orders').push().set(orderModel.toJson());
          await databaseReference.child('Orders').child(value).remove();
          Get.back();
          utils.showToast("orderRejected".tr);
          getUserToken(orderModel, 'orderRejectedTitle'.tr);
        });
      }
    });
  }

  getUserToken(OrderModel orderModel, String title) async {
    await databaseReference.child('Users').child(orderModel.uid!).once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        UserModel userModel = UserModel.fromJson(Map.from(snapshot.value));
        if (userModel.userToken != null) {
          String body = '';
          if (title == 'orderRejected'.tr) {
            body = 'orderRejectedBody'.tr + ' ' + orderModel.orderId!;
          } else {
            body = 'orderAcceptedBody'.tr + ' ' + orderModel.orderId!;
          }
          SendNotificationInterface().sendNotification(title, body, userModel.userToken!, 'Order');
        }
      }
    });
  }
}
