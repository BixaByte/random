import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/common/common.dart';
import 'package:foodizm_driver_app/models/cart_model.dart';
import 'package:foodizm_driver_app/models/order_model.dart';
import 'package:foodizm_driver_app/models/user_model.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:foodizm_driver_app/widget/order_details_items_widget.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final UserModel? userModel;
  final List<CartModel>? orderItems;
  final String? status;

  const OrderDetailsScreen({Key? key, this.status, this.orderModel, this.userModel, this.orderItems}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> with WidgetsBindingObserver {
  Utils utils = new Utils();
  var dropOffLocationController = new TextEditingController();
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    dropOffLocationController.text = widget.orderModel!.origin!;
    WidgetsBinding.instance.addObserver(this);
    Utils().getUserCurrentLocation('');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Utils().driverOfflineMethod();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Utils().getUserCurrentLocation('');
    } else if (state == AppLifecycleState.inactive) {
      Common.locationStream.cancel();
      Utils().driverOfflineMethod();
    } else if (state == AppLifecycleState.paused) {
      Common.locationStream.cancel();
      Utils().driverOfflineMethod();
    }
    print('Current state = $state');
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
                    Expanded(
                      flex: 8,
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
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          openMap(double.parse(widget.orderModel!.latitude!), double.parse(widget.orderModel!.longitude!));
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset('assets/images/direction.png', height: 60, width: 60),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                      child: widget.userModel!.profilePicture == null
                          ? SvgPicture.asset('assets/images/man.svg')
                          : widget.userModel!.profilePicture != 'default'
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: widget.userModel!.profilePicture!,
                                    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                      height: 30,
                                      width: 30,
                                      child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    ),
                                    errorWidget: (context, url, error) => SvgPicture.asset('assets/images/man.svg'),
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
                              widget.userModel!.fullName != null && widget.userModel!.fullName != 'default' ? widget.userModel!.fullName : 'N/A',
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
              ),
              Container(
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
                          widget.userModel!.phoneNumber != null && widget.userModel!.phoneNumber != 'default' ? widget.userModel!.phoneNumber : 'N/A',
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
                          _launchCaller("tel:" + widget.userModel!.phoneNumber!);
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset('assets/images/call_user.png', height: 60, width: 60),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: utils.poppinsSemiBoldText('Order Items', 16.0, AppColors.blackColor, TextAlign.center),
              ),
              for (int i = 0; i < widget.orderItems!.length; i++) OrderDetailsItemsWidget(orderItems: widget.orderItems![i]),
              SizedBox(height: 20),
              if (widget.status == 'Ongoing')
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: SlideAction(
                    onSubmit: () {
                      changeOrderStatus('delivered', widget.orderModel!);
                    },
                    height: 45,
                    submittedIcon: Icon(Icons.check_rounded, color: AppColors.whiteColor),
                    sliderRotate: false,
                    alignment: Alignment.centerRight,
                    innerColor: AppColors.whiteColor,
                    outerColor: AppColors.primaryColor,
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 10.0),
                      child: utils.poppinsMediumText('Slide to complete this order', 14.0, AppColors.whiteColor, TextAlign.center),
                    ),
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
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
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
          Get.back();
          utils.showToast("Order Delivered Successfully");
        });
      }
    });
  }
}
