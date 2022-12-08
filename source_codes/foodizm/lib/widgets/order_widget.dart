import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/models/order_model.dart';
import 'package:foodizm/screens/order_details_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatefulWidget {
  final OrderModel? orderModel;

  const OrderWidget({Key? key, this.orderModel}) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => OrderDetailsScreen(
              orderId: widget.orderModel!.orderId,
              status: widget.orderModel!.status,
              totalAmount: widget.orderModel!.totalPrice,
            ));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          elevation: 2,
          shadowColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                utils.poppinsSemiBoldText('orderNo'.tr + ' : ' + widget.orderModel!.orderId!, 16.0, AppColors.blackColor, TextAlign.center),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            utils.poppinsMediumText(
                                DateFormat("dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.orderModel!.orderId!))),
                                15.0,
                                AppColors.blackColor,
                                TextAlign.center),
                            utils.poppinsMediumText(
                                DateFormat("hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.orderModel!.orderId!))),
                                15.0,
                                AppColors.blackColor,
                                TextAlign.center),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 35,
                          width: 150,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: Center(child: utils.poppinsMediumText('details'.tr, 16.0, AppColors.blackColor, TextAlign.center)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
