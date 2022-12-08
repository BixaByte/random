import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/common/common.dart';
import 'package:foodizm_driver_app/models/order_model.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:foodizm_driver_app/widget/order_widget.dart';
import 'package:get/get.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasData = false.obs;

  late StreamSubscription<Event> orderUpdate;
  late StreamSubscription<Event> orderAdded;
  late StreamSubscription<Event> orderRemoved;

  @override
  void initState() {
    super.initState();
    Common.orderModel.clear();
    getOngoingOrder();
  }

  getOngoingOrder() async {
    orderAdded = databaseReference.child('Orders').orderByChild('driverUid').equalTo(utils.getUserId()).onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        Common.orderModel.add(OrderModel.fromJson(Map.from(event.snapshot.value)));
      }
    });

    orderRemoved = databaseReference.child('Orders').orderByChild('driverUid').equalTo(utils.getUserId()).onChildRemoved.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        Common.orderModel.removeWhere((element) => element.orderId == list.orderId);
      }
    });

    orderUpdate = databaseReference.child('Orders').orderByChild('driverUid').equalTo(utils.getUserId()).onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        OrderModel list = OrderModel.fromJson(Map.from(event.snapshot.value));
        var index = Common.orderModel.indexWhere((item) => item.orderId == list.orderId);
        Common.orderModel[index] = list;
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
    return Container(
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: utils.helveticaBoldText('My Orders', 22.0, AppColors.blackColor, TextAlign.start),
          ),
          Expanded(
            child: Obx(() {
              if (hasData.value) {
                if (Common.orderModel.length > 0) {
                  return SingleChildScrollView(
                    child: Column(children: [
                      for (int i = 0; i < Common.orderModel.length; i++)
                        OrderWidget(
                          status: 'Ongoing',
                          orderModel: Common.orderModel[i],
                          function: (String status, OrderModel orderModel) {
                            if (status == 'delivered') {
                              changeOrderStatus(status, orderModel);
                            }
                          },
                        )
                    ]),
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

  changeOrderStatus(String status, OrderModel orderModel) async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).update({
            'timeDelivered': DateTime.now().millisecondsSinceEpoch.toString(),
            'status': status,
          });
          await databaseReference.child('Drivers').child(utils.getUserId()).update({'onlineStatus': 'free'});
          Get.back();
          utils.showToast("Order Delivered Successfully");
        });
      }
    });
  }
}
