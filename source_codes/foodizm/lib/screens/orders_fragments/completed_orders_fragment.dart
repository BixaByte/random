import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/order_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/order_widget.dart';
import 'package:get/get.dart';

class CompletedOrdersFragment extends StatefulWidget {
  const CompletedOrdersFragment({Key? key}) : super(key: key);

  @override
  _CompletedOrdersFragmentState createState() => _CompletedOrdersFragmentState();
}

class _CompletedOrdersFragmentState extends State<CompletedOrdersFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;
  late StreamSubscription<Event> orderUpdate;
  late StreamSubscription<Event> orderAdded;
  late StreamSubscription<Event> orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.completedOrderModel.clear();
    if (utils.getUserId() != null) {
      showCompletedOrders();
    }
  }

  showCompletedOrders() async {
    orderAdded = databaseReference.child('Delivered_Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.completedOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value)));
      }
    });

    orderRemoved = databaseReference.child('Delivered_Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        Common.completedOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Delivered_Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        var index = Common.completedOrderModel.indexWhere((item) => item.orderId == list.orderId);
        Common.completedOrderModel[index] = list;
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
        if (Common.completedOrderModel.length > 0) {
          return SingleChildScrollView(
            child: Column(
                children: [for (int i = 0; i < Common.completedOrderModel.length; i++) OrderWidget(orderModel: Common.completedOrderModel[i])]),
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
