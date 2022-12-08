import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/cart_model.dart';
import 'package:foodizm/models/variation_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class CheckoutItemWidget extends StatefulWidget {
  final CartModel? cartModel;

  const CheckoutItemWidget({Key? key, this.cartModel}) : super(key: key);

  @override
  _CheckoutItemWidgetState createState() => _CheckoutItemWidgetState();
}

class _CheckoutItemWidgetState extends State<CheckoutItemWidget> {
  Utils utils = new Utils();
  List<VariationModel>? variationModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    variationModel!.clear();
    if (widget.cartModel!.customizationForVariations != null) {
      for (int i = 0; i < widget.cartModel!.customizationForVariations!.length; i++) {
        Map<String, dynamic> mapOfMaps = Map.from(widget.cartModel!.customizationForVariations![i]!);
        variationModel!.add(VariationModel.fromJson(Map.from(mapOfMaps)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 8,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 140),
                  child: Card(
                    elevation: 2,
                    shadowColor: AppColors.paymentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10, left: 5),
                                child: utils.poppinsMediumText(widget.cartModel!.title!, 16.0, AppColors.blackColor, TextAlign.start),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5, left: 5, bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (drinksName() != "")
                                      utils.poppinsMediumText("drinks".tr + ": " + drinksName(), 12.0, AppColors.blackColor, TextAlign.start),
                                    if (flavoursName() != "")
                                      utils.poppinsMediumText("flavours".tr + ": " + flavoursName(), 12.0, AppColors.blackColor, TextAlign.start),
                                    if (variationsName() != "")
                                      utils.poppinsMediumText("items".tr + ": " + variationsName(), 12.0, AppColors.blackColor, TextAlign.start),
                                    if (ingredientsName() != "")
                                      utils.poppinsMediumText("ingredients".tr + ": " + ingredientsName(), 12.0, AppColors.blackColor, TextAlign.start),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: utils.poppinsSemiBoldText('x' + widget.cartModel!.quantity!, 16.0, AppColors.blackColor, TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, left: 5),
                                child: utils.poppinsMediumText(
                                    Common.currency + widget.cartModel!.newPrice!, 16.0, AppColors.blackColor, TextAlign.start),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            decoration: new BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryColor),
            ),
            height: 100,
            width: 100,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: widget.cartModel!.image != null && widget.cartModel!.image != 'default'
                    ? CachedNetworkImage(
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        imageUrl: widget.cartModel!.image!,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                          height: 30,
                          width: 30,
                          child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                        ),
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images/placeholder_image.png", height: 60, width: 60, fit: BoxFit.cover),
                      )
                    : Image.asset("assets/images/placeholder_image.png", height: 60, width: 60, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  variationsName() {
    String text = '';
    if (widget.cartModel!.customizationForVariations != null) {
      if (variationModel!.length > 0 && widget.cartModel!.customizationForVariations!.length > 0) {
        if (variationModel![0].name != 'default') {
          for (int i = 0; i < variationModel!.length; i++) {
            if (text == '') {
              text = variationModel![i].name!;
            } else {
              text = text + ', ' + variationModel![i].name!;
            }
          }
        }
      }
    }
    return text;
  }

  flavoursName() {
    String text = '';
    if (widget.cartModel!.customizationForFlavours != null) {
      if (widget.cartModel!.customizationForFlavours!.length > 0) {
        if (widget.cartModel!.customizationForFlavours![0] != 'default') {
          text = widget.cartModel!.customizationForFlavours![0];
        }
      }
    }
    return text;
  }

  drinksName() {
    String text = '';
    if (widget.cartModel!.customizationForDrinks != null) {
      if (widget.cartModel!.customizationForDrinks!.length > 0) {
        if (widget.cartModel!.customizationForDrinks![0] != 'default') {
          text = widget.cartModel!.customizationForDrinks![0];
        }
      }
    }
    return text;
  }

  ingredientsName() {
    String text = '';
    if (widget.cartModel!.ingredients != null) {
      if (widget.cartModel!.ingredients!.length > 0) {
        if (widget.cartModel!.ingredients![0] != 'default') {
          text = widget.cartModel!.ingredients![0];
        }
      }
    }
    return text;
  }
}
