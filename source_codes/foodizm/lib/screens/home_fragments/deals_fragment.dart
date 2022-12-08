import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/widgets/deals_widget.dart';
import 'package:get/get.dart';

class DealsFragment extends StatefulWidget {
  const DealsFragment({Key? key}) : super(key: key);

  @override
  _DealsFragmentState createState() => _DealsFragmentState();
}

class _DealsFragmentState extends State<DealsFragment> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            utils.helveticaBoldText('allDeals'.tr, 22.0, AppColors.lightGrey2Color, TextAlign.start),
            Obx(() {
              if (Common.dealsList.length > 0) {
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    itemCount: Common.dealsList.length,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, i) => DealsWidget(dealsModel: Common.dealsList[i], width: Get.width),
                  ),
                );
              } else {
                return utils.noDataWidget('noDealsFound'.tr, Get.height * 0.7);
              }
            })
          ],
        ),
      ),
    );
  }
}
