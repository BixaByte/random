import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/product_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';

class ProductsWidget extends StatefulWidget {
  final ProductModel? productModel;

  const ProductsWidget({Key? key, this.productModel}) : super(key: key);

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
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
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                child: widget.productModel!.image != null && widget.productModel!.image != 'default'
                    ? CachedNetworkImage(
                        height: 120,
                        width: Get.width,
                        fit: BoxFit.cover,
                        imageUrl: widget.productModel!.image!,
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
            Padding(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              child: utils.helveticaSemiBold2Lines(widget.productModel!.title!, 13.0, AppColors.blackColor, TextAlign.start),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  utils.poppinsSemiBoldText(Common.currency + widget.productModel!.price!, 13.0, AppColors.primaryColor, TextAlign.start),
                  utils.poppinsRegularText('Serving ${widget.productModel!.noOfServing!} guest', 12.0, AppColors.lightGreyColor, TextAlign.start),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
