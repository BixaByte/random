
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/order_widget.dart';
import 'package:get/get.dart';

class DeliveredOrdersFragment extends StatefulWidget {
  const DeliveredOrdersFragment({Key? key}) : super(key: key);

  @override
  _DeliveredOrdersFragmentState createState() => _DeliveredOrdersFragmentState();
}

class _DeliveredOrdersFragmentState extends State<DeliveredOrdersFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;
  late StreamSubscription<Event> orderUpdate;
  late StreamSubscription<Event> orderAdded;
  late StreamSubscription<Event> orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.deliveredOrderModel.clear();
    showDeliveredOrders();
  }


  showDeliveredOrders() async {
    orderAdded = databaseReference.child('Delivered_Orders').onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.deliveredOrderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value)));
      }
    });

    orderRemoved = databaseReference.child('Delivered_Orders').onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        Common.deliveredOrderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Delivered_Orders').onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        var index = Common.deliveredOrderModel.indexWhere((item) => item.orderId == list.orderId);
        Common.deliveredOrderModel[index] = list;
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
        if (Common.deliveredOrderModel.length > 0) {
          return SingleChildScrollView(
            child: Column(children: [
              for (int i = 0; i < Common.deliveredOrderModel.length; i++)
                OrderWidget(
                  status: 'Delivered',
                  orderModel: Common.deliveredOrderModel[i],
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
