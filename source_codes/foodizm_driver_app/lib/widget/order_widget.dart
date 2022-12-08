import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/common/common.dart';
import 'package:foodizm_driver_app/models/cart_model.dart';
import 'package:foodizm_driver_app/models/order_model.dart';
import 'package:foodizm_driver_app/models/user_model.dart';
import 'package:foodizm_driver_app/screens/order_details_screen.dart';
import 'package:foodizm_driver_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';

class OrderWidget extends StatefulWidget {
  final String? status;
  final OrderModel? orderModel;
  final Function? function;

  const OrderWidget({Key? key, this.status, this.orderModel, this.function}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Utils utils = new Utils();
  var dropOffLocationController = new TextEditingController();
  RxList<CartModel> orderItems = <CartModel>[].obs;
  Rx<UserModel> userModel = new UserModel().obs;

  @override
  void initState() {
    super.initState();
    dropOffLocationController.text = widget.orderModel!.origin!;
    getCustomerDetails();

    if (widget.orderModel!.items != null) {
      for (int i = 0; i < widget.orderModel!.items!.length; i++) {
        Map<String, dynamic> mapOfMaps = Map.from(widget.orderModel!.items![i]!);
        orderItems.add(CartModel.fromJson(Map.from(mapOfMaps)));
      }
    }
  }

  getCustomerDetails() async {
    await FirebaseDatabase.instance.reference().child('Users').child(widget.orderModel!.uid!).once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.exists) {
        userModel.value = UserModel.fromJson(Map.from(dataSnapshot.value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => OrderDetailsScreen(status: widget.status, orderModel: widget.orderModel!, orderItems: orderItems, userModel: userModel.value));
      },
      child: Card(
        elevation: 2,
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
            margin: EdgeInsets.all(5),
            child: Obx(() => Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(minHeight: 50.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
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
                                          errorWidget: (context, url, error) => SvgPicture.asset('assets/images/man.svg'),
                                        ),
                                      )
                                    : SvgPicture.asset('assets/images/man.svg'),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        utils.poppinsMediumText(
                                          userModel.value.fullName != null && userModel.value.fullName != 'default'
                                              ? userModel.value.fullName
                                              : 'N/A',
                                          16.0,
                                          AppColors.blackColor,
                                          TextAlign.start,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          width: 80,
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                          decoration:
                                              BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                          child: Center(
                                              child: utils.poppinsMediumText(
                                                  widget.orderModel!.paymentType!, 12.0, AppColors.whiteColor, TextAlign.center)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: utils.poppinsSemiBoldText(
                                      Common.currency + widget.orderModel!.totalPrice!,
                                      12.0,
                                      AppColors.blackColor,
                                      TextAlign.start,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: AppColors.whiteColor,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
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
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5, top: 10),
                                child: utils.poppinsSemiBoldText('Status : ', 14.0, AppColors.lightGrey2Color, TextAlign.start),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, top: 10),
                                child: utils.poppinsSemiBoldText(widget.orderModel!.status!, 14.0, AppColors.blackColor, TextAlign.start),
                              )
                            ],
                          ),
                          if (widget.status == 'Ongoing')
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: SlideAction(
                                onSubmit: () {
                                  widget.function!('delivered', widget.orderModel!);
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
                          if (widget.status == 'Previous')
                            InkWell(
                              onTap: () {
                                Get.to(() => OrderDetailsScreen(
                                    status: widget.status, orderModel: widget.orderModel!, orderItems: orderItems, userModel: userModel.value));
                              },
                              child: Container(
                                height: 45,
                                margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                child: Center(child: utils.poppinsMediumText('View Order', 16.0, AppColors.whiteColor, TextAlign.center)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}
