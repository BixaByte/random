import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/variation_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class SelectItemWidget extends StatefulWidget {
  final List<VariationModel>? variationModel;
  final Function? function;

  const SelectItemWidget({Key? key, this.variationModel,this.function}) : super(key: key);

  @override
  _SelectItemWidgetState createState() => _SelectItemWidgetState();
}

class _SelectItemWidgetState extends State<SelectItemWidget> {
  Utils utils = new Utils();
  RxInt variationValue = 0.obs;
  RxString variationName = ''.obs;
  RxString variationPrice = ''.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    variationName.value = widget.variationModel![0].name!;
    variationPrice.value = widget.variationModel![0].price!;
    widget.function!(variationName.value,variationPrice.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          child: utils.poppinsSemiBoldText('selectItem'.tr, 14.0, AppColors.blackColor, TextAlign.start),
        ),
        for (int i = 0; i < widget.variationModel!.length; i++)
          Obx(() => InkWell(
                onTap: () {
                  variationValue.value = i;
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Radio(
                        value: i,
                        groupValue: variationValue.value,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          variationValue.value = int.parse(value.toString());
                          variationName.value = widget.variationModel![int.parse(value.toString())].name!;
                          variationPrice.value = widget.variationModel![int.parse(value.toString())].price!;
                          widget.function!(variationName.value,variationPrice.value);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            utils.poppinsRegularText(widget.variationModel![i].name, 12.0, AppColors.blackColor, TextAlign.start),
                            utils.poppinsRegularText(Common.currency + widget.variationModel![i].price!, 12.0, AppColors.blackColor, TextAlign.start),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }
}
