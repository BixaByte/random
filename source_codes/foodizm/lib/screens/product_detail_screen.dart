import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/deals_model.dart';
import 'package:foodizm/models/product_model.dart';
import 'package:foodizm/models/variation_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/not_login_widget.dart';
import 'package:foodizm/widgets/select_item_widget.dart';
import 'package:foodizm/widgets/select_drink_widget.dart';
import 'package:foodizm/widgets/select_flavour_widget.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? type;
  final ProductModel? productModel;
  final DealsModel? dealsModel;

  const ProductDetailScreen({Key? key, this.type, this.productModel, this.dealsModel}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Utils utils = new Utils();
  RxInt itemIndex = 1.obs;
  List<VariationModel>? variationModel = [];
  RxString flavourName = ''.obs;
  RxString drinkName = ''.obs;
  RxString variationName = ''.obs;
  RxString variationPrice = ''.obs;
  var databaseReference = FirebaseDatabase.instance.reference();

  placeholderImage() {
    return Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover, height: 200, width: Get.width);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    variationModel!.clear();
    if (widget.type == 'Items') {
      for (int i = 0; i < widget.productModel!.customizationForVariations!.length; i++) {
        Map<String, dynamic> mapOfMaps = Map.from(widget.productModel!.customizationForVariations![i]!);
        variationModel!.add(VariationModel.fromJson(Map.from(mapOfMaps)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText(
            widget.type == 'Deals' ? widget.dealsModel!.title! : widget.productModel!.title!, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: Stack(
                children: [
                  widget.type == 'Deals'
                      ? widget.dealsModel!.image != null && widget.dealsModel!.image != 'default'
                          ? CachedNetworkImage(
                              height: 200,
                              width: Get.width,
                              fit: BoxFit.cover,
                              imageUrl: widget.dealsModel!.image!,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => placeholderImage(),
                            )
                          : placeholderImage()
                      : widget.productModel!.image != null && widget.productModel!.image != 'default'
                          ? CachedNetworkImage(
                              height: 200,
                              width: Get.width,
                              fit: BoxFit.cover,
                              imageUrl: widget.productModel!.image!,
                              progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                height: 50,
                                width: 50,
                                child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                              ),
                              errorWidget: (context, url, error) => placeholderImage(),
                            )
                          : placeholderImage(),
                  if (widget.type == 'Deals')
                    Align(
                      alignment: Alignment.topRight,
                      child: Card(
                        color: AppColors.redColor,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: utils.poppinsMediumText(widget.dealsModel!.discount! + ' %', 12.0, AppColors.whiteColor, TextAlign.center),
                        ),
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: utils.poppinsSemiBoldText(
                  widget.type == 'Deals' ? widget.dealsModel!.title! : widget.productModel!.title!, 14.0, AppColors.blackColor, TextAlign.start),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      utils.poppinsSemiBoldText(
                          Common.currency + (widget.type == 'Deals' ? widget.dealsModel!.newPrice! : widget.productModel!.price!),
                          16.0,
                          AppColors.primaryColor,
                          TextAlign.start),
                      if (widget.type == 'Deals')
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: utils.poppinsRegularTextLineTrough(
                              Common.currency + widget.dealsModel!.oldPrice!, 14.0, AppColors.lightGreyColor, TextAlign.start),
                        )
                    ],
                  ),
                  utils.poppinsRegularText(
                      'Serving ${widget.type == 'Deals' ? widget.dealsModel!.noOfServing! : widget.productModel!.noOfServing!} guest',
                      12.0,
                      AppColors.lightGreyColor,
                      TextAlign.start),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: utils.poppinsRegularText( widget.type == 'Deals' ? widget.dealsModel!.details! : widget.productModel!.details!, 12.0, AppColors.blackColor, TextAlign.start),
            ),
            if (widget.type == 'Items') widget.productModel!.ingredients![0] != 'default' ? ingredientsWidget() : Container(),
            if (widget.type == 'Deals') widget.dealsModel!.itemsIncluded![0] != 'default' ? itemIncludedWidget() : Container(),
            if (widget.type == 'Deals')
              widget.dealsModel!.customizationForDrinks![0] != 'default'
                  ? SelectDrinkWidget(
                      drinks: widget.dealsModel!.customizationForDrinks!,
                      function: (String name) {
                        drinkName.value = name;
                      },
                    )
                  : Container(),
            if (widget.type == 'Deals')
              widget.dealsModel!.customizationForFlavours![0] != 'default'
                  ? SelectFlavourWidget(
                      flavours: widget.dealsModel!.customizationForFlavours!,
                      function: (String name) {
                        flavourName.value = name;
                      },
                    )
                  : Container(),
            if (widget.type == 'Items')
              widget.productModel!.customizationForFlavours![0] != 'default'
                  ? SelectFlavourWidget(
                      flavours: widget.productModel!.customizationForFlavours!,
                      function: (String name) {
                        flavourName.value = name;
                      },
                    )
                  : Container(),
            if (widget.type == 'Items')
              variationModel![0].name != 'default'
                  ? SelectItemWidget(
                      variationModel: variationModel!,
                      function: (String name, String price) {
                        variationName.value = name;
                        variationPrice.value = price;
                      },
                    )
                  : Container(),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    return Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: () {
                              if (itemIndex > 1) {
                                itemIndex.value = itemIndex.value - 1;
                              }
                            },
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: AppColors.primaryColor,
                              size: 27.0,
                            ),
                          ),
                        ),
                        utils.poppinsSemiBoldText('$itemIndex', 16.0, AppColors.blackColor, TextAlign.center),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: InkWell(
                            onTap: () {
                              itemIndex.value = itemIndex.value + 1;
                            },
                            child: Icon(
                              Icons.add_circle_outlined,
                              color: AppColors.primaryColor,
                              size: 27.0,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  InkWell(
                      onTap: () {
                        if (utils.getUserId() == null) {
                          showDialog(
                            context: context,
                            builder: (_) => NotLoginWidget('Dialog'),
                          );
                        } else {
                          widget.type == 'Items' ? addToCartProduct() : addToCartDeal();
                        }
                      },
                      child: SvgPicture.asset('assets/images/add_to_cart.svg')),
                ],
              ),
            ),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  ingredientsWidget() {
    if (widget.productModel!.ingredients!.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: utils.poppinsSemiBoldText('ingredients'.tr, 14.0, AppColors.blackColor, TextAlign.start),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: utils.poppinsRegularText(showIngredients(), 12.0, AppColors.blackColor, TextAlign.start),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  showIngredients() {
    String name = '';
    for (int i = 0; i < widget.productModel!.ingredients!.length; i++) {
      if (name == '') {
        name = name + widget.productModel!.ingredients![i];
      } else {
        name = name + ',' + widget.productModel!.ingredients![i];
      }
    }
    return name;
  }

  itemIncludedWidget() {
    if (widget.dealsModel!.itemsIncluded!.length > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
            child: utils.poppinsSemiBoldText('itemIncluded'.tr, 14.0, AppColors.blackColor, TextAlign.start),
          ),
          for (int i = 0; i < widget.dealsModel!.itemsIncluded!.length; i++)
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: utils.poppinsRegularText(widget.dealsModel!.itemsIncluded![i], 12.0, AppColors.blackColor, TextAlign.start),
            ),
        ],
      );
    } else {
      return Container();
    }
  }

  void addToCartProduct() async {
    utils.showLoadingDialog();
    String timeAdded = DateTime.now().millisecondsSinceEpoch.toString();
    List<String>? customizationForFlavours = [];
    List<Map<String, dynamic>?>? customizationForVariations = [];
    if (widget.productModel!.customizationForFlavours![0] != 'default') {
      List<String> flavours = [];
      flavours.add(flavourName.value);
      customizationForFlavours = flavours;
    } else {
      customizationForFlavours = widget.productModel!.customizationForFlavours;
    }

    if (variationModel![0].name != 'default') {
      List<Map<String, dynamic>?>? variationModel = [];
      variationModel.add({'name': variationName.value, 'price': variationPrice.value});
      customizationForVariations = variationModel;
    } else {
      customizationForVariations = widget.productModel!.customizationForVariations;
    }

    Map<dynamic, dynamic> data = {
      "categoryId": widget.productModel!.categoryId!,
      "title": widget.productModel!.title!,
      "details": widget.productModel!.details!,
      "image": widget.productModel!.image!,
      "type": widget.productModel!.type!,
      "no_of_serving": widget.productModel!.noOfServing!,
      "timeCreated": widget.productModel!.timeCreated!,
      "newPrice": widget.productModel!.price!,
      "quantity": itemIndex.value.toString(),
      "uid": utils.getUserId(),
      "timeAdded": timeAdded,
      "ingredients": widget.productModel!.ingredients!,
      "customizationForVariations": customizationForVariations,
      "customizationForFlavours": customizationForFlavours
    };

    Query query = databaseReference.child('Cart').orderByChild('timeCreated').equalTo(widget.productModel!.timeCreated!);
    await query.once().then((DataSnapshot snapshot) {
      if (!snapshot.exists) {
        databaseReference.child('Cart').push().set(data);
        Get.back();
        utils.showToast('itemAddedInCart'.tr);
      } else {
        List<String> uid = [];
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          uid.add(value['uid']);
        });

        if (uid.contains(utils.getUserId())) {
          increaseItemQuantity(widget.productModel!.timeCreated!);
        } else {
          databaseReference.child('Cart').push().set(data);
          Get.back();
          utils.showToast('itemAddedInCart'.tr);
        }
      }
    });
  }

  void addToCartDeal() async {
    utils.showLoadingDialog();
    String timeAdded = DateTime.now().millisecondsSinceEpoch.toString();
    List<String>? customizationForFlavours = [];
    List<String>? customizationForDrinks = [];
    if (widget.dealsModel!.customizationForFlavours![0] != 'default') {
      List<String> flavours = [];
      flavours.add(flavourName.value);
      customizationForFlavours = flavours;
    } else {
      customizationForFlavours = widget.dealsModel!.customizationForFlavours;
    }

    if (widget.dealsModel!.customizationForDrinks![0] != 'default') {
      List<String> drinks = [];
      drinks.add(drinkName.value);
      customizationForDrinks = drinks;
    } else {
      customizationForDrinks = widget.dealsModel!.customizationForDrinks;
    }

    Map<dynamic, dynamic> data = {
      "categoryId": 'default',
      "title": widget.dealsModel!.title!,
      "details": widget.dealsModel!.details!,
      "image": widget.dealsModel!.image!,
      "type": widget.dealsModel!.type!,
      "noOfServing": widget.dealsModel!.noOfServing!,
      "timeCreated": widget.dealsModel!.timeCreated!,
      "discount": widget.dealsModel!.discount!,
      "expiryDate": widget.dealsModel!.expiryDate!,
      "validDate": widget.dealsModel!.validDate!,
      "newPrice": widget.dealsModel!.newPrice!,
      "oldPrice": widget.dealsModel!.oldPrice!,
      "quantity": itemIndex.value.toString(),
      "uid": utils.getUserId(),
      "timeAdded": timeAdded,
      "itemsIncluded": widget.dealsModel!.itemsIncluded!,
      "customizationForDrinks": customizationForDrinks,
      "customizationForFlavours": customizationForFlavours
    };

    Query query = databaseReference.child('Cart').orderByChild('timeCreated').equalTo(widget.dealsModel!.timeCreated!);
    await query.once().then((DataSnapshot snapshot) {
      if (!snapshot.exists) {
        databaseReference.child('Cart').push().set(data);
        Get.back();
        utils.showToast('itemAddedInCart'.tr);
      } else {
        List<String> uid = [];
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          uid.add(value['uid']);
        });

        if (uid.contains(utils.getUserId())) {
          increaseItemQuantity(widget.dealsModel!.timeCreated!);
        } else {
          databaseReference.child('Cart').push().set(data);
          Get.back();
          utils.showToast('itemAddedInCart'.tr);
        }
      }
    });
  }

  increaseItemQuantity(String timeCreated) async {
    Query query = databaseReference.child('Cart').orderByChild('timeCreated').equalTo(timeCreated);
    query.once().then((DataSnapshot snapshot) {
      Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
      mapOfMaps.values.forEach((value) {
        if (value['uid'].toString() == utils.getUserId()) {
          var encoded = jsonEncode(snapshot.value);
          var decoded = jsonDecode(encoded);
          databaseReference.child('Cart').child(decoded.keys.toString().replaceAll('(', '').replaceAll(')', '')).update({
            'quantity': (int.parse(value['quantity']) + itemIndex.value).toString(),
          });
          Get.back();
          utils.showToast('itemAddedInCart'.tr);
        }
      });
    });
  }
}
