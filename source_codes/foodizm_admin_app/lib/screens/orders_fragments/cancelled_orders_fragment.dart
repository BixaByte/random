import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/order_widget.dart';
import 'package:get/get.dart';

class CancelledOrdersFragment extends StatefulWidget {
  const CancelledOrdersFragment({Key? key}) : super(key: key);

  @override
  _CancelledOrdersFragmentState createState() => _CancelledOrdersFragmentState();
}

class _CancelledOrdersFragmentState extends State<CancelledOrdersFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;
  late StreamSubscription<Event> orderUpdate;
  late StreamSubscription<Event> orderAdded;
  late StreamSubscription<Event> orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.cancelledOrderModel.clear();
    showCancelledOrders();
  }

  showCancelledOrders() async {
    orderAdded = databaseReference.child('Cancelled_Orders').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.cancelledOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value)));
      }
    });

    orderRemoved = databaseReference.child('Cancelled_Orders').onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        Common.cancelledOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Cancelled_Orders').onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        var index = Common.cancelledOrderModel.indexWhere((item) => item.orderId == list.orderId);
        Common.cancelledOrderModel[index] = list;
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
        if (Common.cancelledOrderModel.length > 0) {
          return SingleChildScrollView(
            child: Column(children: [
              for (int i = 0; i < Common.cancelledOrderModel.length; i++)
                OrderWidget(
                  status: 'Cancelled',
                  orderModel: Common.cancelledOrderModel[i],
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
