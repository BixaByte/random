import 'package:flutter/material.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/models/cart_model.dart';
import 'package:foodizm_driver_app/models/variation_model.dart';
import 'package:foodizm_driver_app/utils/utils.dart';

class OrderDetailsItemsWidget extends StatefulWidget {
  final CartModel? orderItems;

  const OrderDetailsItemsWidget({Key? key, this.orderItems}) : super(key: key);

  @override
  _OrderDetailsItemsWidgetState createState() => _OrderDetailsItemsWidgetState();
}

class _OrderDetailsItemsWidgetState extends State<OrderDetailsItemsWidget> {
  Utils utils = new Utils();
  List<VariationModel>? variationModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    variationModel!.clear();
    if (widget.orderItems!.type == 'item') {
      if (widget.orderItems!.customizationForVariations != null) {
        for (int i = 0; i < widget.orderItems!.customizationForVariations!.length; i++) {
          Map<String, dynamic> mapOfMaps = Map.from(widget.orderItems!.customizationForVariations![i]!);
          variationModel!.add(VariationModel.fromJson(Map.from(mapOfMaps)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: utils.poppinsMediumText(
          'x ' + widget.orderItems!.quantity! + " = " + setText(widget.orderItems!), 14.0, AppColors.blackColor, TextAlign.start),
    );
  }

  setText(CartModel orderItems) {
    String text = '';
    if (orderItems.type == 'deal') {
      if (orderItems.customizationForDrinks!.length > 0 && orderItems.customizationForFlavours!.length > 0) {
        if (orderItems.customizationForDrinks![0] != 'default' && orderItems.customizationForFlavours![0] != 'default') {
          text = orderItems.title! + ' ( ' + orderItems.customizationForDrinks![0] + " , " + orderItems.customizationForFlavours![0] + " , )";
        } else if (orderItems.customizationForDrinks![0] != 'default') {
          text = orderItems.title! + ' ( ' + orderItems.customizationForDrinks![0] + " )";
        } else if (orderItems.customizationForFlavours![0] != 'default') {
          text = orderItems.title! + ' ( ' + orderItems.customizationForFlavours![0] + " )";
        } else {
          text = orderItems.title!;
        }
      }
    } else if (orderItems.type == 'item') {
      if (variationModel!.length > 0 && orderItems.customizationForFlavours!.length > 0) {
        if (variationModel![0].name != 'default' && orderItems.customizationForFlavours![0] != 'default') {
          text = orderItems.title! + ' ( ' + variationModel![0].name! + " , " + orderItems.customizationForFlavours![0] + " , )";
        } else if (variationModel![0].name != 'default') {
          text = orderItems.title! + ' ( ' + variationModel![0].name! + " )";
        } else if (orderItems.customizationForFlavours![0] != 'default') {
          text = orderItems.title! + ' ( ' + orderItems.customizationForFlavours![0] + " )";
        } else {
          text = orderItems.title!;
        }
      }
    }

    return text;
  }
}
