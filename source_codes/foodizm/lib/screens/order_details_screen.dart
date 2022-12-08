import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/cart_model.dart';
import 'package:foodizm/models/order_model.dart';
import 'package:foodizm/screens/track_order_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/order_details_items_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderId, status, totalAmount;

  const OrderDetailsScreen({Key? key, this.orderId, this.status, this.totalAmount}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  Rx<OrderModel> orderDetails = new OrderModel().obs;
  RxList<CartModel> orderItems = <CartModel>[].obs;
  RxBool hasData = false.obs;

  @override
  void initState() {
    super.initState();
    if (widget.status == 'completed') {
      getCompletedOrderDetails();
    } else if (widget.status == 'rejected') {
      getCancelledOrderDetails();
    } else {
      getOrderDetails();
    }
  }

  getCompletedOrderDetails() async {
    Query query = databaseReference.child('Delivered_Orders').orderByChild('orderId').equalTo(widget.orderId!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          orderDetails.value = OrderModel.fromJson(Map.from(value));
        });
        for (int i = 0; i < orderDetails.value.items!.length; i++) {
          Map<String, dynamic> mapOfMaps = Map.from(orderDetails.value.items![i]!);
          orderItems.add(CartModel.fromJson(Map.from(mapOfMaps)));
        }
      }
      hasData.value = true;
    });
  }

  getCancelledOrderDetails() async {
    Query query = databaseReference.child('Cancelled_Orders').orderByChild('orderId').equalTo(widget.orderId!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          orderDetails.value = OrderModel.fromJson(Map.from(value));
        });
        for (int i = 0; i < orderDetails.value.items!.length; i++) {
          Map<String, dynamic> mapOfMaps = Map.from(orderDetails.value.items![i]!);
          orderItems.add(CartModel.fromJson(Map.from(mapOfMaps)));
        }
      }
      hasData.value = true;
    });
  }

  getOrderDetails() async {
    Query query = databaseReference.child('Orders').orderByChild('orderId').equalTo(widget.orderId!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          orderDetails.value = OrderModel.fromJson(Map.from(value));
        });
        for (int i = 0; i < orderDetails.value.items!.length; i++) {
          Map<String, dynamic> mapOfMaps = Map.from(orderDetails.value.items![i]!);
          orderItems.add(CartModel.fromJson(Map.from(mapOfMaps)));
        }
      }
      hasData.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText(widget.orderId!, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Obx(() {
          if (hasData.value) {
            if (orderDetails.value.orderId != null) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    utils.poppinsSemiBoldText('myOrders'.tr, 18.0, AppColors.blackColor, TextAlign.center),
                    Stack(
                      children: [
                        if (widget.status != 'rejected')
                          Container(
                            height: 350,
                            margin: EdgeInsets.only(top: 20),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: buildLeftWidget(
                                        'requested'.tr,
                                        'ic_requested',
                                        DateFormat("hh:mm a")
                                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDetails.value.timeRequested!))),
                                      ),
                                    ),
                                    Expanded(
                                      child: buildRightWidget(
                                        'accepted'.tr,
                                        orderDetails.value.timeAccepted != 'default' ? 'ic_accepted' : 'not_accepted',
                                        orderDetails.value.timeAccepted == 'default'
                                            ? '00:00'
                                            : DateFormat("hh:mm a")
                                                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDetails.value.timeAccepted!))),
                                      ),
                                    ),
                                    Expanded(
                                      child: buildLeftWidget(
                                        'preparing'.tr,
                                        orderDetails.value.timeStartPreparing != 'default' ? 'ic_preparing' : 'not_preparing',
                                        orderDetails.value.timeStartPreparing == 'default'
                                            ? '00:00'
                                            : DateFormat("hh:mm a")
                                                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDetails.value.timeStartPreparing!))),
                                      ),
                                    ),
                                    Expanded(
                                      child: buildRightWidget(
                                        'onTheWay'.tr,
                                        orderDetails.value.timeOnTheWay != 'default' ? 'ic_on_the_way' : 'not_on_the_way',
                                        orderDetails.value.timeOnTheWay == 'default'
                                            ? '00:00'
                                            : DateFormat("hh:mm a")
                                                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDetails.value.timeOnTheWay!))),
                                      ),
                                    ),
                                    Expanded(
                                      child: buildLeftWidget(
                                        'delivered1'.tr,
                                        orderDetails.value.timeDelivered != 'default' ? 'ic_delivered' : 'not_delivered',
                                        orderDetails.value.timeDelivered == 'default'
                                            ? '00:00'
                                            : DateFormat("hh:mm a")
                                                .format(DateTime.fromMillisecondsSinceEpoch(int.parse(orderDetails.value.timeDelivered!))),
                                      ),
                                    )
                                  ],
                                ),
                                Center(
                                  child: FAProgressBar(
                                    direction: Axis.vertical,
                                    verticalDirection: VerticalDirection.down,
                                    size: 10.0,
                                    maxValue: 100,
                                    currentValue: progress(),
                                    displayTextStyle: TextStyle(color: Colors.transparent),
                                    displayText: '',
                                    changeProgressColor: AppColors.primaryColor,
                                    backgroundColor: AppColors.greyColor,
                                    progressColor: AppColors.primaryColor,
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: orderDetails.value.timeAccepted != 'default' ? AppColors.primaryColor : AppColors.greyColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: orderDetails.value.timeStartPreparing != 'default' ? AppColors.primaryColor : AppColors.greyColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: orderDetails.value.timeOnTheWay != 'default' ? AppColors.primaryColor : AppColors.greyColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: orderDetails.value.timeDelivered != 'default' ? AppColors.primaryColor : AppColors.greyColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.status == 'rejected')
                          Container(
                            height: 250,
                            margin: EdgeInsets.only(top: 20),
                            child: Center(
                              child: utils.poppinsBoldText('orderCancelled'.tr, 20.0, AppColors.redColor, TextAlign.center),
                            ),
                          ),
                      ],
                    ),
                    if (widget.status == 'onTheWay' || widget.status == 'delivered')
                      InkWell(
                        onTap: () {
                          Get.to(() => TrackOrderScreen(driverId: orderDetails.value.driverUid, dropOffLocation: orderDetails.value.origin));
                        },
                        child: Container(
                          height: 45,
                          width: Get.width,
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: Center(child: utils.poppinsMediumText('trackYourOrder'.tr, 16.0, AppColors.primaryColor, TextAlign.center)),
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          utils.poppinsSemiBoldText('orderDetails'.tr, 14.0, AppColors.blackColor, TextAlign.center),
                          utils.poppinsSemiBoldText(
                            'date'.tr + ' : ' + DateFormat("dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.orderId!))),
                            14.0,
                            AppColors.blackColor,
                            TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          utils.poppinsSemiBoldText(orderItems.length.toString() + ' ' + 'items'.tr, 14.0, AppColors.blackColor, TextAlign.center),
                          utils.poppinsSemiBoldText(
                              'total'.tr + ' : ' + Common.currency + ' ' + widget.totalAmount!, 14.0, AppColors.blackColor, TextAlign.center),
                        ],
                      ),
                    ),
                    for (int i = 0; i < orderItems.length; i++) OrderDetailsItemsWidget(orderItems: orderItems[i]),
                    if (widget.status == 'onTheWay' || widget.status == 'delivered')
                      InkWell(
                        onTap: () {
                          showConfirmationDialog();
                        },
                        child: Container(
                          height: 45,
                          width: Get.width,
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            border: Border.all(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          ),
                          child: Center(child: utils.poppinsMediumText('confirmOrderReceived'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor),
            );
          }
        }),
      ),
    );
  }

  progress() {
    int progress = 20;
    if (orderDetails.value.timeDelivered != 'default') {
      progress = 100;
    } else if (orderDetails.value.timeOnTheWay != 'default') {
      progress = 80;
    } else if (orderDetails.value.timeStartPreparing != 'default') {
      progress = 60;
    } else if (orderDetails.value.timeAccepted != 'default') {
      progress = 40;
    } else {
      progress = 20;
    }
    return progress;
  }

  buildLeftWidget(text, icon, time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              utils.poppinsMediumText(text, 14.0, AppColors.blackColor, TextAlign.start),
              utils.poppinsRegularText(time, 14.0, AppColors.blackColor, TextAlign.start)
            ],
          ),
        ),
        Expanded(
          child: SvgPicture.asset('assets/images/order_images/$icon.svg'),
        ),
      ],
    );
  }

  buildRightWidget(text, icon, time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SvgPicture.asset('assets/images/order_images/$icon.svg'),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              utils.poppinsMediumText(text, 14.0, AppColors.blackColor, TextAlign.start),
              utils.poppinsRegularText(time, 14.0, AppColors.blackColor, TextAlign.start)
            ],
          ),
        ),
      ],
    );
  }

  void showConfirmationDialog() {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "getOrder".tr,
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("no".tr),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          changeTimeDelivered();
        },
        child: Text("yes".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }

  changeTimeDelivered() async {
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(widget.orderId!);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).update({
            'timeDelivered': DateTime.now().millisecondsSinceEpoch.toString(),
            'status': 'completed',
          });
          addToDelivered(value.toString());
        });
      }
    });
  }

  addToDelivered(String node) async {
    await databaseReference.child('Orders').child(node).once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        OrderModel orderModel = new OrderModel.fromJson(Map.from(snapshot.value));
        await databaseReference.child('All_Orders').child(DateFormat('dd-MM-yyyy').format(DateTime.now())).push().set({
          'orderId': orderModel.orderId,
          'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
        increaseTotalOrder(orderModel.items);
        await databaseReference.child('Delivered_Orders').push().set(orderModel.toJson());
        await databaseReference.child('Orders').child(node).remove();
        Get.back();
        utils.showToast("orderCompleted".tr);
      }
    });
  }

  increaseTotalOrder(List<Map<String, dynamic>?>? items) async {
    for (int i = 0; i < items!.length; i++) {
      Query query;
      if (items[i]!['type'] == 'deal') {
        query = databaseReference.child('Deals').orderByChild("timeCreated").equalTo(items[i]!['timeCreated']);
      } else {
        query = databaseReference.child('Items').orderByChild("timeCreated").equalTo(items[i]!['timeCreated']);
      }

      await query.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
          mapOfMaps.keys.forEach((value) async {
            Query query1;
            if (items[i]!['type'] == 'deal') {
              query1 = databaseReference.child('Deals').child(value).child('totalOrder');
            } else {
              query1 = databaseReference.child('Items').child(value).child('totalOrder');
            }
            await query1.once().then((DataSnapshot snapshot) {
              if (snapshot.exists) {
                if (items[i]!['type'] == 'deal') {
                  databaseReference.child('Deals').child(value).update({'totalOrder': snapshot.value + 1});
                } else {
                  databaseReference.child('Items').child(value).update({'totalOrder': snapshot.value + 1});
                }
              } else {
                if (items[i]!['type'] == 'deal') {
                  databaseReference.child('Deals').child(value).update({'totalOrder': 1});
                } else {
                  databaseReference.child('Items').child(value).update({'totalOrder': 1});
                }
              }
            });
          });
        }
      });
    }
  }
}
