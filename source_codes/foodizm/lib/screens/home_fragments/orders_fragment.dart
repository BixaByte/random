import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/screens/orders_fragments/cancelled_orders_fragment.dart';
import 'package:foodizm/screens/orders_fragments/completed_orders_fragment.dart';
import 'package:foodizm/screens/orders_fragments/delivered_orders_fragment.dart';
import 'package:foodizm/screens/orders_fragments/ongoing_orders_fragment.dart';
import 'package:foodizm/screens/orders_fragments/pending_orders_fragment.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/not_login_widget.dart';
import 'package:get/get.dart';

class OrdersFragment extends StatefulWidget {
  const OrdersFragment({Key? key}) : super(key: key);

  @override
  _OrdersFragmentState createState() => _OrdersFragmentState();
}

class _OrdersFragmentState extends State<OrdersFragment> with SingleTickerProviderStateMixin {
  Utils utils = new Utils();
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          utils.helveticaBoldText('myOrders'.tr, 22.0, AppColors.lightGrey2Color, TextAlign.start),
          Container(
            height: 45,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(25.0)),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(borderRadius: BorderRadius.circular(25.0), color: AppColors.primaryColor),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'pending'.tr),
                Tab(text: 'ongoing'.tr),
                Tab(text: 'delivered'.tr),
                Tab(text: 'completed'.tr),
                Tab(text: 'cancelled'.tr),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                utils.getUserId() == null ? NotLoginWidget('') : PendingOrdersFragment(),
                utils.getUserId() == null ? NotLoginWidget('') : OngoingOrdersFragment(),
                utils.getUserId() == null ? NotLoginWidget('') : DeliveredOrdersFragment(),
                utils.getUserId() == null ? NotLoginWidget('') : CompletedOrdersFragment(),
                utils.getUserId() == null ? NotLoginWidget('') : CancelledOrdersFragment(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
