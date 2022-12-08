import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/order_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/order_widget.dart';
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
    if (utils.getUserId() != null) {
      showPendingOrders();
    }
  }

  showPendingOrders() async {
    orderAdded = databaseReference.child('Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value['status'] == 'requested') {
          Common.pendingOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value)));
        }
      }
    });

    orderRemoved = databaseReference.child('Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        Common.pendingOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value['status'] == 'requested') {
          OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
          var index = Common.pendingOrderModel.indexWhere((item) => item.orderId == list.orderId);
          Common.pendingOrderModel[index] = list;
        } else {
          OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
          Common.pendingOrderModel.removeWhere((element) => element.orderId == list.orderId);
        }
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
            child: Column(children: [for (int i = 0; i < Common.pendingOrderModel.length; i++) OrderWidget(orderModel: Common.pendingOrderModel[i])]),
          );
        } else {
          return utils.noDataWidget('noOrder'.tr, Get.height);
        }
      } else {
        return Container(
          height: Get.height,
          child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
        );
      }
    });
  }
}
