import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/database_model/deals_model.dart';
import 'package:foodizm_admin_app/database_model/product_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/bar_chart_widget.dart';
import 'package:foodizm_admin_app/widget/deal_pie_chart_widget.dart';
import 'package:foodizm_admin_app/widget/item_pie_chart_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SalesFragment extends StatefulWidget {
  const SalesFragment({Key? key}) : super(key: key);

  @override
  _SalesFragmentState createState() => _SalesFragmentState();
}

class _SalesFragmentState extends State<SalesFragment> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();
  RxBool hasAllOrder = false.obs;
  RxBool hasDealOrder = false.obs;
  RxBool hasItemOrder = false.obs;

  @override
  void initState() {
    super.initState();
    Common.monGraph.value = '0';
    Common.tueGraph.value = '0';
    Common.wedGraph.value = '0';
    Common.thuGraph.value = '0';
    Common.friGraph.value = '0';
    Common.satGraph.value = '0';
    Common.sunGraph.value = '0';
    getAllOrders();
    getItemOrder();
    getDealOrders();
  }

  getAllOrders() async {
    await databaseReference.child('All_Orders').limitToLast(7).once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          switch (DateFormat('EEEE').format(DateFormat("dd-MM-yyyy").parse(value.toString()))) {
            case "Monday":
              await databaseReference.child('All_Orders').child(value.toString()).once().then((DataSnapshot snapshot) {
                Map data = snapshot.value;
                Common.monGraph.value = data.length.toString();
              });
              return;
            case "Tuesday":
              await databaseReference.child('All_Orders').child(value.toString()).once().then((DataSnapshot snapshot) {
                Map data = snapshot.value;
                Common.tueGraph.value = data.length.toString();
              });
              return;
            case "Wednesday":
              await databaseReference.child('All_Orders').child(value.toString()).once().then((DataSnapshot snapshot) {
                Map data = snapshot.value;
                Common.wedGraph.value = data.length.toString();
              });
              return;
            case "Thursday":
              await databaseReference.child('All_Orders').child(value.toString()).once().then((DataSnapshot snapshot) {
                Map data = snapshot.value;
                Common.thuGraph.value = data.length.toString();
              });
              return;
            case "Friday":
              await databaseReference.child('All_Orders').child(value.toString()).once().then((DataSnapshot snapshot) {
                Map data = snapshot.value;
                Common.friGraph.value = data.length.toString();
              });
              return;
            case "Saturday":
              await databaseReference.child('All_Orders').child(value.toString()).once().then((DataSnapshot snapshot) {
                Map data = snapshot.value;
                Common.satGraph.value = data.length.toString();
              });
              return;
            case "Sunday":
              await databaseReference.child('All_Orders').child(value.toString()).once().then((DataSnapshot snapshot) {
                Map data = snapshot.value;
                Common.sunGraph.value = data.length.toString();
              });
              return;
          }
        });
      }
      hasAllOrder.value = true;
    });
  }

  getItemOrder() async {
    Common.totalItemOrder.clear();
    await databaseReference.child('Items').orderByChild('totalOrder').limitToLast(4).once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.totalItemOrder.add(ProductModel.fromJson(Map.from(value)));
        });
      }
      hasItemOrder.value = true;
    });
  }

  getDealOrders() async {
    Common.totalDealsOrder.clear();
    await databaseReference.child('Deals').orderByChild('totalOrder').limitToLast(4).once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.values.forEach((value) {
          Common.totalDealsOrder.add(DealsModel.fromJson(Map.from(value)));
        });
      }
      hasDealOrder.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utils.helveticaBoldText('sales'.tr, 22.0, AppColors.blackColor, TextAlign.start),
            Obx(() {
              if (hasAllOrder.value) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: BarChartWidget(),
                );
              } else {
                return Container();
              }
            }),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: utils.helveticaBoldText('itemSales'.tr, 18.0, AppColors.blackColor, TextAlign.start),
            ),
            Obx(() {
              if (hasItemOrder.value) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ItemPieChartWidget(),
                );
              } else {
                return Container();
              }
            }),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: utils.helveticaBoldText('dealSales'.tr, 18.0, AppColors.blackColor, TextAlign.start),
            ),
            Obx(() {
              if (hasDealOrder.value) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: DealPieChartWidget(),
                );
              } else {
                return Container();
              }
            }),
          ],
        ),
      ),
    );
  }
}
