import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/deals_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';

class DealsWidget extends StatefulWidget {
  final DealsModel? dealsModel;

  const DealsWidget({Key? key, this.dealsModel}) : super(key: key);

  @override
  _DealsWidgetState createState() => _DealsWidgetState();
}

class _DealsWidgetState extends State<DealsWidget> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: Card(
        elevation: 2,
        shadowColor: AppColors.paymentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              child: Stack(
                children: [
                  Container(
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                      child: widget.dealsModel!.image != null && widget.dealsModel!.image != 'default'
                          ? CachedNetworkImage(
                              height: 120,
                              width: Get.width,
                              fit: BoxFit.cover,
                              imageUrl: widget.dealsModel!.image!,
                              progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                height: 50,
                                width: 50,
                                child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset("assets/images/placeholder_image.png", height: 120, width: Get.width, fit: BoxFit.cover),
                            )
                          : Image.asset("assets/images/placeholder_image.png", height: 120, width: Get.width, fit: BoxFit.cover),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      color: AppColors.redColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: utils.poppinsMediumText('${widget.dealsModel!.discount!} %', 12.0, AppColors.whiteColor, TextAlign.center),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              child: utils.helveticaSemiBold2Lines(widget.dealsModel!.title!, 13.0, AppColors.blackColor, TextAlign.start),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      utils.poppinsSemiBoldText(Common.currency + widget.dealsModel!.newPrice!, 13.0, AppColors.primaryColor, TextAlign.start),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: utils.poppinsRegularTextLineTrough(
                            Common.currency + widget.dealsModel!.oldPrice!, 10.0, AppColors.lightGreyColor, TextAlign.start),
                      )
                    ],
                  ),
                  utils.poppinsRegularText('Serving ${widget.dealsModel!.noOfServing!} guest', 12.0, AppColors.lightGreyColor, TextAlign.start),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
