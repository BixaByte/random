import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:get/get.dart';
import 'package:foodizm_admin_app/screens/orders_fragments/accepted_orders_fragment.dart';
import 'package:foodizm_admin_app/screens/orders_fragments/cancelled_orders_fragment.dart';
import 'package:foodizm_admin_app/screens/orders_fragments/delivered_orders_fragment.dart';
import 'package:foodizm_admin_app/screens/orders_fragments/ontheway_orders_fragment.dart';
import 'package:foodizm_admin_app/screens/orders_fragments/pending_orders_fragment.dart';
import 'package:foodizm_admin_app/screens/orders_fragments/preparing_orders_fragment.dart';
import 'package:foodizm_admin_app/utils/utils.dart';

class OrderFragment extends StatefulWidget {
  const OrderFragment({Key? key}) : super(key: key);

  @override
  _OrderFragmentState createState() => _OrderFragmentState();
}

class _OrderFragmentState extends State<OrderFragment> with SingleTickerProviderStateMixin {
  Utils utils = new Utils();
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
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
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          utils.helveticaBoldText('orders'.tr, 22.0, AppColors.blackColor, TextAlign.start),
          Container(
            height: 45,
            margin: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(25.0)),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(borderRadius: BorderRadius.circular(25.0), color: AppColors.primaryColor),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'pending'.tr),
                Tab(text: 'accepted'.tr),
                Tab(text: 'preparing'.tr),
                Tab(text: 'onTheWay'.tr),
                Tab(text: 'delivered'.tr),
                Tab(text: 'cancelled'.tr),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PendingOrdersFragment(),
                AcceptedOrdersFragment(),
                PreparingOrdersFragment(),
                OnTheWayOrdersFragment(),
                DeliveredOrdersFragment(),
                CancelledOrdersFragment(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
