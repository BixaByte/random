import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/order_widget.dart';
import 'package:get/get.dart';

class PreparingOrdersFragment extends StatefulWidget {
  const PreparingOrdersFragment({Key? key}) : super(key: key);

  @override
  _PreparingOrdersFragmentState createState() => _PreparingOrdersFragmentState();
}

class _PreparingOrdersFragmentState extends State<PreparingOrdersFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;

  late StreamSubscription<Event> orderUpdate;
  late StreamSubscription<Event> orderAdded;
  late StreamSubscription<Event> orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.preparingOrderModel.clear();
    showPreparingOrders();
  }

  showPreparingOrders() async {
    orderAdded = databaseReference.child('Orders').orderByChild('status').equalTo('preparing').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.preparingOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value)));
      }
    });

    orderRemoved = databaseReference.child('Orders').orderByChild('status').equalTo('preparing').onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        Common.preparingOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Orders').orderByChild('status').equalTo('preparing').onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        var index = Common.preparingOrderModel.indexWhere((item) => item.orderId == list.orderId);
        Common.preparingOrderModel[index] = list;
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
        if (Common.preparingOrderModel.length > 0) {
          return SingleChildScrollView(
            child: Column(children: [
              for (int i = 0; i < Common.preparingOrderModel.length; i++)
                OrderWidget(
                  status: 'Preparing',
                  orderModel: Common.preparingOrderModel[i],
                  function: () {},
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
}
