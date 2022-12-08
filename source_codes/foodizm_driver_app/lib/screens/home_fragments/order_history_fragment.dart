import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/models/order_model.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:foodizm_driver_app/widget/order_widget.dart';
import 'package:get/get.dart';

class OrderHistoryFragment extends StatefulWidget {
  const OrderHistoryFragment({Key? key}) : super(key: key);

  @override
  _OrderHistoryFragmentState createState() => _OrderHistoryFragmentState();
}

class _OrderHistoryFragmentState extends State<OrderHistoryFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxList<OrderModel> orderModel = <OrderModel>[].obs;
  RxBool hasData = false.obs;

  @override
  void initState() {
    super.initState();
    getCompletedOrder();
  }

  getCompletedOrder() async {
    await databaseReference.child('Delivered_Orders').orderByChild('driverUid').equalTo(utils.getUserId()).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        orderModel.clear();
        Map<String, dynamic> mapOfMaps = Map.from(dataSnapshot.value);
        mapOfMaps.values.forEach((value) {
          orderModel.add(OrderModel.fromJson(Map.from(value)));
        });
      }
      hasData.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: utils.helveticaBoldText('Order History', 22.0, AppColors.blackColor, TextAlign.start),
          ),
          Expanded(
            child: Obx(() {
              if (hasData.value) {
                if (orderModel.length > 0) {
                  return SingleChildScrollView(
                    child:
                        Column(children: [for (int i = 0; i < orderModel.length; i++) OrderWidget(status: 'Previous', orderModel: orderModel[i])]),
                  );
                } else {
                  return utils.noDataWidget('No Orders Found', Get.height);
                }
              } else {
                return Container(
                  height: Get.height,
                  child: Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
                );
              }
            }),
          )
        ],
      ),
    );
  }
}
