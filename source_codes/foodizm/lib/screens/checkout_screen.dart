
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/charges_model.dart';
import 'package:foodizm/models/restaurant_details_model.dart';
import 'package:foodizm/screens/all_adresses_screen.dart';
import 'package:foodizm/screens/payment_method_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/checkout_item_widget.dart';
import 'package:foodizm/widgets/send_notification_interface.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  final String? totalPrice;

  const CheckoutScreen({Key? key, this.totalPrice}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Utils utils = new Utils();
  RxString? lat = ''.obs;
  RxString? lng = ''.obs;
  RxString? address = ''.obs;
  RxDouble? taxes = 0.0.obs;
  RxDouble? freeDeliveryRadius = 0.0.obs;
  RxDouble? maxRadius = 0.0.obs;
  RxDouble? deliveryFeePerKm = 0.0.obs;
  var databaseReference = FirebaseDatabase.instance.reference();
  Rx<ChargesModel> chargesModel = new ChargesModel().obs;
  Rx<RestaurantDetailsModel> restaurantDetails = new RestaurantDetailsModel().obs;
  RxDouble? distanceInKm = 0.0.obs;
  RxBool showButton = false.obs;
  RxString? paymentType = ''.obs;
  RxString? deliveryPrice = ''.obs;
  RxString? taxPrice = ''.obs;
  RxString? grandTotalPrice = ''.obs;

  @override
  void initState() {
    super.initState();
    Common.cardNumber = null;
    Common.selectedAddress = null;
    Common.selectedLat = null;
    Common.selectedLng = null;
    if (Common.currentAddress != null) {
      lat!.value = Common.currentLat!;
      lng!.value = Common.currentLng!;
      address!.value = Common.currentAddress!;
    }
    getCharges();
  }

  getCharges() async {
    Query query = databaseReference.child('Charges');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        chargesModel.value = ChargesModel.fromJson(Map.from(snapshot.value));
        taxes!.value = double.parse(chargesModel.value.taxes!);
        freeDeliveryRadius!.value = double.parse(chargesModel.value.freeDeliveryRadius!);
        maxRadius!.value = double.parse(chargesModel.value.maxRadius!);
        deliveryFeePerKm!.value = double.parse(chargesModel.value.deliveryFeePerKm!);
        getRestaurantDetails();
      }
    });
  }

  getRestaurantDetails() async {
    Query query = databaseReference.child('RestaurantDetails');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        restaurantDetails.value = RestaurantDetailsModel.fromJson(Map.from(snapshot.value));
        calculateDistance(
            double.parse(lat!.value), double.parse(lng!.value), double.parse(restaurantDetails.value.lat!), double.parse(restaurantDetails.value.lng!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('myOrder'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < Common.cartModel.length; i++) CheckoutItemWidget(cartModel: Common.cartModel[i]),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          showChooseAddressDialog();
                        },
                        child: Container(
                          height: 100,
                          child: buildBox('address'.tr, 16.0, 'assets/images/all_address.svg', AppColors.addressColor),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          showChoosePaymentDialog();
                        },
                        child: Obx(() => Container(
                              height: 100,
                              child: buildBox(showText(paymentType!.value), fontSize(paymentType!.value), 'assets/images/payment.svg', AppColors.paymentColor),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: utils.poppinsSemiBoldText('deliverTo'.tr + ' : ', 16.0, AppColors.blackColor, TextAlign.center),
                ),
              ),
              Obx(() => utils.poppinsMediumText(
                    address!.value,
                    16.0,
                    AppColors.blackColor,
                    TextAlign.start,
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: utils.poppinsSemiBoldText('paymentSummary'.tr + ' : ', 16.0, AppColors.blackColor, TextAlign.center),
                ),
              ),
              paymentSummary('subTotal'.tr, Common.currency + widget.totalPrice!),
              Obx(() => paymentSummary('delivery'.tr, deliveryPrice!.value)),
              Obx(() => paymentSummary('taxes'.tr, taxPrice!.value)),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    utils.poppinsSemiBoldText('total'.tr, 16.0, AppColors.blackColor, TextAlign.center),
                    Obx(() => utils.poppinsSemiBoldText(Common.currency + grandTotalPrice!.value, 16.0, AppColors.blackColor, TextAlign.center))
                  ],
                ),
              ),
              SizedBox(height: 30),
              Obx(
                () => InkWell(
                  onTap: () {
                    if (showButton.value) {
                      if (paymentType!.value == '') {
                        utils.showToast('choosePaymentMethod'.tr);
                      } else if (paymentType!.value == 'card'.tr && Common.cardNumber == null) {
                        utils.showToast('pleaseChooseCard'.tr);
                      } else {
                        payOrder();
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    width: Get.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Center(
                      child: utils.poppinsMediumText(showButton.value ? 'payPlaceOrder'.tr : 'doNotDeliver'.tr, 16.0, AppColors.whiteColor, TextAlign.center),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  void showChooseAddressDialog() {
    Get.defaultDialog(
      title: "chooseAddress".tr,
      content: Text(
        "whichLocation".tr,
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
          if (Common.currentAddress != null) {
            lat!.value = Common.currentLat!;
            lng!.value = Common.currentLng!;
            address!.value = Common.currentAddress!;
          }
        },
        child: Text("useCurrent".tr),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          Get.to(() => AllAddressesScreen(origin: 'choose'))!.then((value) {
            if (Common.selectedAddress != null) {
              address!.value = Common.selectedAddress!;
              lat!.value = Common.selectedLat!;
              lng!.value = Common.selectedLng!;
              calculateDistance(
                  double.parse(lat!.value), double.parse(lng!.value), double.parse(restaurantDetails.value.lat!), double.parse(restaurantDetails.value.lng!));
            }
          });
        },
        child: Text("fromSaved".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }

  void showChoosePaymentDialog() {
    Get.defaultDialog(
      title: "choosePayment".tr,
      content: Text(
        "whichPayment".tr,
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
          paymentType!.value = 'cash'.tr;
        },
        child: Text("cash".tr),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          paymentType!.value = 'card'.tr;
          Get.back();
          Get.to(() => PaymentMethodScreen(origin: 'choose'))!.then((value) {
            if (Common.cardNumber != null) {
              paymentType!.value = Common.cardNumber!;
            }
          });
        },
        child: Text("card".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }

  buildBox(text, fontSize, icon, color) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(icon, height: 20, width: 20, color: AppColors.blackColor),
          utils.poppinsMediumText(text, fontSize, AppColors.blackColor, TextAlign.center)
        ],
      ),
    );
  }

  showText(text) {
    String newText = '';
    if (text == '') {
      newText = 'payment'.tr;
    } else if (text == 'cash'.tr) {
      newText = 'cash'.tr;
    } else if (text == 'card'.tr) {
      newText = 'card'.tr;
    } else {
      newText = hideCardNum(text);
    }

    return newText;
  }

  fontSize(text) {
    double size = 0.0;
    if (text == '') {
      size = 16.0;
    } else if (text == 'cash'.tr || text == 'card'.tr) {
      size = 16.0;
    } else {
      size = 12.0;
    }

    return size;
  }

  hideCardNum(String number) {
    String result = "";
    result = number.substring(0, 4) + " **** **** " + number.substring(number.length - 4);
    return result;
  }

  paymentSummary(text, text2) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          utils.poppinsMediumText(text, 16.0, AppColors.blackColor, TextAlign.center),
          utils.poppinsMediumText(text2, 16.0, AppColors.blackColor, TextAlign.center)
        ],
      ),
    );
  }

  calculateDistance(lat1, lon1, lat2, lon2) async {
    Dio dio = new Dio();
    var response = await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$lat1,$lon1&destinations=$lat2,$lon2&"
        "key=${Common.apiKey!}");
    print(response.data);

    if (response.data['rows'][0]['elements'][0]['distance'] == null) {
      showButton.value = false;
      return;
    }

    String data = response.data['rows'][0]['elements'][0]['distance']['value'].toString();
    distanceInKm!.value = double.parse(data.replaceAll(",", "").split(' ')[0]) / 1000; // * 1.60934

    print(distanceInKm!.value);

    double? totalDelivery = 0.0;

    if (maxRadius!.value < distanceInKm!.value) {
      showButton.value = false;
    } else if (distanceInKm!.value > freeDeliveryRadius!.value) {
      showButton.value = true;
      double minusRadius = distanceInKm!.value - freeDeliveryRadius!.value;
      totalDelivery = minusRadius * deliveryFeePerKm!.value;
      deliveryPrice!.value = totalDelivery.toStringAsFixed(2) + ' ' + Common.currency;
    } else {
      showButton.value = true;
      deliveryPrice!.value = 'free'.tr;
    }

    if (deliveryPrice!.value != 'free'.tr) {
      double totalAmount = double.parse(widget.totalPrice!) + totalDelivery;
      double percentage = totalAmount * taxes!.value;
      double percentageAmount = percentage / 100;
      taxPrice!.value = percentageAmount.toStringAsFixed(2) + "(" + taxes!.value.toStringAsFixed(2) + "%)" + ' ' + Common.currency;
      grandTotalPrice!.value = (double.parse(widget.totalPrice!) + totalDelivery + percentageAmount).toStringAsFixed(2);
    } else {
      double totalAmount = double.parse(widget.totalPrice!);
      double percentage = totalAmount * taxes!.value;
      double percentageAmount = percentage / 100;
      taxPrice!.value = percentageAmount.toStringAsFixed(2) + "(" + taxes!.value.toStringAsFixed(2) + "%)" + ' ' + Common.currency;
      grandTotalPrice!.value = (double.parse(widget.totalPrice!) + percentageAmount).toStringAsFixed(2);
    }
  }

  payOrder() async {
    utils.showLoadingDialog();
    List<Map<String, dynamic>?>? items = [];
    for (int i = 0; i < Common.cartModel.length; i++) {
      Map<String, dynamic> data = {
        "categoryId": Common.cartModel[i].categoryId,
        "title": Common.cartModel[i].title,
        "details": Common.cartModel[i].details,
        "image": Common.cartModel[i].image,
        "type": Common.cartModel[i].type,
        "no_of_serving": Common.cartModel[i].noOfServing,
        "timeCreated": Common.cartModel[i].timeCreated,
        "oldPrice": Common.cartModel[i].oldPrice,
        "newPrice": Common.cartModel[i].newPrice,
        "quantity": Common.cartModel[i].quantity,
        "uid": Common.cartModel[i].uid,
        "timeAdded": Common.cartModel[i].timeAdded,
        "ingredients": Common.cartModel[i].ingredients,
        "customizationForVariations": Common.cartModel[i].customizationForVariations,
        "customizationForFlavours": Common.cartModel[i].customizationForFlavours,
        "customizationForDrinks": Common.cartModel[i].customizationForDrinks,
        "itemsIncluded": Common.cartModel[i].itemsIncluded,
      };
      items.add(data);
    }

    Map<String, dynamic> orderData = {
      "items": items,
      "totalPrice": grandTotalPrice!.value,
      "orderId": DateTime.now().millisecondsSinceEpoch.toString(),
      "status": 'requested',
      "origin": address!.value,
      "latitude": lat!.value,
      "longitude": lng!.value,
      "timeRequested": DateTime.now().millisecondsSinceEpoch.toString(),
      "paymentType": paymentType!.value == 'Cash' ? 'Cash' : 'Card',
      "timeAccepted": 'default',
      "timeStartPreparing": 'default',
      "timeOnTheWay": 'default',
      "timeDelivered": 'default',
      "uid": utils.getUserId(),
    };

    await databaseReference.child('Orders').push().set(orderData).then((value) {
      removedItemFromCart();
    }).onError((error, stackTrace) {
      Get.back();
      utils.showToast(error.toString());
    });
  }

  removedItemFromCart() async {
    Query query = databaseReference.child('Cart').orderByChild('uid').equalTo(utils.getUserId());
    await query.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Cart').child(value).remove();
          Get.back();
          Common.cardNumber = null;
          Common.selectedAddress = null;
          Common.selectedLat = null;
          Common.selectedLng = null;
          Common.cartModel.clear();
          Get.back();
          utils.showToast('orderPlaced'.tr);
          if (restaurantDetails.value.userToken != null) {
            String body = 'newOrderFrom'.tr + ' ' + Common.userModel.fullName!;
            SendNotificationInterface().sendNotification('New Order', body, restaurantDetails.value.userToken!, 'Order');
          }
        });
      }
    });
  }
}
