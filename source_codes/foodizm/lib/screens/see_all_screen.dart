import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/deals_widget.dart';
import 'package:foodizm/widgets/products_widget.dart';
import 'package:get/get.dart';

class SeeAllScreen extends StatefulWidget {
  final String? title;

  const SeeAllScreen({Key? key, this.title}) : super(key: key);

  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText(widget.title, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          crossAxisCount: 2,
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          itemCount: 10,
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) => showWidget(i),
        ),
      ),
    );
  }

  showWidget(int i) {
    if (widget.title == 'All Deals') return DealsWidget(dealsModel: Common.dealsList[i], width: Get.width);
    if (widget.title == 'All Popular') return ProductsWidget(productModel: Common.popularProductList[i], width: Get.width, origin: 'popular');
    if (widget.title == 'All Latest Dishes') return ProductsWidget(productModel: Common.latestProductList[i], width: Get.width, origin: 'latest');
  }
}
