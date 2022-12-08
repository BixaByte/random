import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/database_model/order_model.dart';
import 'package:foodizm_admin_app/screens/driver_fragments/busy_driver_fragment.dart';
import 'package:foodizm_admin_app/screens/driver_fragments/free_driver_fragment.dart';
import 'package:foodizm_admin_app/utils/utils.dart';

class MyDriverScreen extends StatefulWidget {
  final OrderModel? orderModel;

  const MyDriverScreen({Key? key, this.orderModel}) : super(key: key);


  @override
  _MyDriverScreenState createState() => _MyDriverScreenState();
}

class _MyDriverScreenState extends State<MyDriverScreen> with SingleTickerProviderStateMixin {
  Utils utils = new Utils();
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('My Drivers', 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 45,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(25.0)),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicator: BoxDecoration(borderRadius: BorderRadius.circular(25.0), color: AppColors.primaryColor),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'Free Drivers'),
                Tab(text: 'Busy Drivers'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FreeDriverFragment(orderModel: widget.orderModel),
                BusyDriverFragment(orderModel: widget.orderModel),
              ],
            ),
          )
        ],
      ),
    );
  }
}
