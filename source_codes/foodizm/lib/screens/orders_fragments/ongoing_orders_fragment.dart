import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/order_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/order_widget.dart';
import 'package:get/get.dart';

class OngoingOrdersFragment extends StatefulWidget {
  const OngoingOrdersFragment({Key? key}) : super(key: key);

  @override
  _OngoingOrdersFragmentState createState() => _OngoingOrdersFragmentState();
}

class _OngoingOrdersFragmentState extends State<OngoingOrdersFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;
  late StreamSubscription<Event> orderUpdate;
  late StreamSubscription<Event> orderAdded;
  late StreamSubscription<Event> orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.ongoingOrderModel.clear();
    if (utils.getUserId() != null) {
      showOngoingOrders();
    }
  }

  showOngoingOrders() async {
    orderAdded = databaseReference.child('Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value['status'] == 'accepted' ||
            event.snapshot.value['status'] == 'preparing' ||
            event.snapshot.value['status'] == 'onTheWay') {
          Common.ongoingOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value)));
        }
      }
    });

    orderRemoved = databaseReference.child('Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        Common.ongoingOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Orders').orderByChild('uid').equalTo(utils.getUserId()).onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value['status'] == 'accepted' ||
            event.snapshot.value['status'] == 'preparing' ||
            event.snapshot.value['status'] == 'onTheWay') {
          OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
          var index = Common.ongoingOrderModel.indexWhere((item) => item.orderId == list.orderId);
          Common.ongoingOrderModel[index] = list;
        } else {
          OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
          Common.ongoingOrderModel.removeWhere((element) => element.orderId == list.orderId);
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
        if (Common.ongoingOrderModel.length > 0) {
          return SingleChildScrollView(
            child: Column(children: [for (int i = 0; i < Common.ongoingOrderModel.length; i++) OrderWidget(orderModel: Common.ongoingOrderModel[i])]),
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
