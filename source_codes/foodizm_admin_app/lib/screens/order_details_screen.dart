import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/database_model/cart_model.dart';
import 'package:foodizm_admin_app/database_model/driver_model.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/database_model/user_model.dart';
import 'package:foodizm_admin_app/screens/my_drivers_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/order_details_items_widget.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final List<CartModel>? orderItems;
  final String? status;

  const OrderDetailsScreen({Key? key, this.status, this.orderModel, this.orderItems}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Utils utils = new Utils();
  var dropOffLocationController = new TextEditingController();
  Rx<UserModel> userModel = new UserModel().obs;
  Rx<DriverModel> driverModel = new DriverModel().obs;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    dropOffLocationController.text = widget.orderModel!.origin!;
    getCustomerDetails();

    if (widget.status == 'OnTheWay' || widget.status == 'Delivered') {
      if (widget.orderModel!.driverUid != null) {
        getDriverDetails();
      }
    }
  }

  getCustomerDetails() async {
    await databaseReference.child('Users').child(widget.orderModel!.uid!).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        userModel.value = UserModel.fromJson(Map.from(dataSnapshot.value));
      }
    });
  }

  getDriverDetails() async {
    await databaseReference.child('Drivers').child(widget.orderModel!.driverUid!).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        driverModel.value = DriverModel.fromJson(Map.from(dataSnapshot.value));
      }
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
        title: utils.poppinsMediumText('Order Details', 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 50.0),
                color: Colors.grey.shade100,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: utils.poppinsMediumText("#" + widget.orderModel!.orderId!, 16.0, AppColors.blackColor, TextAlign.start),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/location.svg', color: AppColors.primaryColor, height: 25, width: 25),
                    Expanded(
                      child: TextFormField(
                        controller: dropOffLocationController,
                        minLines: 1,
                        maxLines: 5,
                        enabled: false,
                        decoration: utils.inputDecorationWithLabel('', 'Drop off Location', Colors.transparent, Colors.transparent),
                      ),
                    )
                  ],
                ),
              ),
              Obx(() => Container(
                    constraints: BoxConstraints(minHeight: 50.0),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          decoration: new BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          height: 60,
                          width: 60,
                          child: userModel.value.profilePicture == null
                              ? SvgPicture.asset('assets/images/man.svg')
                              : userModel.value.profilePicture != 'default'
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: userModel.value.profilePicture!,
                                        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                          height: 30,
                                          width: 30,
                                          child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                        ),
                                        errorWidget: (context, url, error) => SvgPicture.asset("assets/images/man.svg", fit: BoxFit.cover),
                                      ),
                                    )
                                  : SvgPicture.asset('assets/images/man.svg'),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                utils.poppinsMediumText(
                                  userModel.value.fullName != null && userModel.value.fullName != 'default' ? userModel.value.fullName : 'N/A',
                                  16.0,
                                  AppColors.blackColor,
                                  TextAlign.start,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: 80,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                  child: Center(
                                      child: utils.poppinsMediumText(widget.orderModel!.paymentType!, 12.0, AppColors.whiteColor, TextAlign.center)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Obx(() => Container(
                    constraints: BoxConstraints(minHeight: 50.0),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 8,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: utils.poppinsMediumText(
                              userModel.value.phoneNumber != null && userModel.value.phoneNumber != 'default' ? userModel.value.phoneNumber : 'N/A',
                              18.0,
                              AppColors.blackColor,
                              TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              if (userModel.value.phoneNumber != null && userModel.value.phoneNumber != 'default') {
                                _launchCaller("tel:" + userModel.value.phoneNumber!);
                              } else {
                                utils.showToast('Phone number not provided');
                              }
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Image.asset('assets/images/call_user.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              if (widget.status == 'OnTheWay' || widget.status == 'Delivered')
                Obx(() => Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: utils.poppinsMediumText('Assign Driver : ', 14.0, AppColors.lightGrey2Color, TextAlign.start),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: utils.poppinsMediumText(
                              driverModel.value.fullName != null && driverModel.value.fullName != 'default' ? driverModel.value.fullName : 'N/A',
                              14.0,
                              AppColors.blackColor,
                              TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    )),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: utils.poppinsSemiBoldText('Order Items', 16.0, AppColors.blackColor, TextAlign.center),
              ),
              for (int i = 0; i < widget.orderItems!.length; i++) OrderDetailsItemsWidget(orderItems: widget.orderItems![i]),
              SizedBox(height: 20),
              if (widget.status == 'Pending' || widget.status == 'Accepted' || widget.status == 'Preparing')
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: SlideAction(
                    onSubmit: () {
                      if (widget.status == 'Pending') {
                        changeAcceptOrderStatus('accepted', widget.orderModel!);
                      } else if (widget.status == 'Accepted') {
                        changeAcceptOrderStatus('preparing', widget.orderModel!);
                      } else if (widget.status == 'Preparing') {
                        Get.to(() => MyDriverScreen(orderModel: widget.orderModel!))!.then((value) {
                          Get.back();
                        });
                      }
                    },
                    height: 45,
                    submittedIcon: Icon(Icons.check_rounded, color: AppColors.whiteColor),
                    sliderRotate: false,
                    alignment: Alignment.centerRight,
                    innerColor: AppColors.whiteColor,
                    outerColor: setColors(),
                    child: utils.poppinsMediumText(setText(), 14.0, AppColors.whiteColor, TextAlign.start),
                    sliderButtonIcon: Icon(Icons.double_arrow_outlined),
                  ),
                ),
              if (widget.status == 'Pending')
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: SlideAction(
                    onSubmit: () {
                      showRejectDialog();
                    },
                    height: 45,
                    sliderRotate: false,
                    submittedIcon: Icon(Icons.close, color: AppColors.whiteColor),
                    alignment: Alignment.centerRight,
                    innerColor: AppColors.whiteColor,
                    outerColor: AppColors.redColor,
                    child: utils.poppinsMediumText('Slide To Reject', 14.0, AppColors.whiteColor, TextAlign.start),
                    sliderButtonIcon: Icon(Icons.double_arrow_outlined),
                  ),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _launchCaller(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  setText() {
    if (widget.status == 'Pending')
      return 'Slide To Accept';
    else if (widget.status == 'Accepted')
      return 'Slide To Start Preparing';
    else if (widget.status == 'Preparing') return 'Slide To Assign Driver';
  }

  setColors() {
    if (widget.status == 'Pending')
      return AppColors.greenColor;
    else if (widget.status == 'Accepted')
      return AppColors.primaryColor;
    else if (widget.status == 'Preparing') return AppColors.primaryColor;
  }

  void showRejectDialog() {
    Get.defaultDialog(
      title: "Confirmation",
      content: Text(
        "Do you want to reject this order?",
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("No"),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          addToCancelledOrder('rejected', widget.orderModel!);
        },
        child: Text("Yes"),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }

  changeAcceptOrderStatus(String status, OrderModel orderModel) async {
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
          Get.back();
          utils.showToast("Order Accepted Successfully");
        });
      }
    });
  }

  changePreparingOrderStatus(String status, OrderModel orderModel) async {
    utils.showLoadingDialog();
    Query query = databaseReference.child('Orders').orderByChild("orderId").equalTo(orderModel.orderId);
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Orders').child(value.toString()).update({
            'timeStartPreparing': DateTime.now().millisecondsSinceEpoch.toString(),
            'status': status,
          });
          Get.back();
          Get.back();
          utils.showToast("Order Start Preparing Successfully");
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
          Get.back();
          utils.showToast("Order Rejected Successfully");
        });
      }
    });
  }
}
