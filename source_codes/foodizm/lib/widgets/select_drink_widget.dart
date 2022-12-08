import 'package:flutter/material.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:foodizm/colors.dart';
import 'package:get/get.dart';

class SelectDrinkWidget extends StatefulWidget {
  final List<String>? drinks;
  final Function? function;
  const SelectDrinkWidget({Key? key, this.drinks,this.function}) : super(key: key);

  @override
  _SelectDrinkWidgetState createState() => _SelectDrinkWidgetState();
}

class _SelectDrinkWidgetState extends State<SelectDrinkWidget> {
  Utils utils = new Utils();
  RxInt drinkValue = 0.obs;
  RxString drinkName = ''.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    drinkName.value = widget.drinks![0];
    widget.function!(drinkName.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          child: utils.poppinsSemiBoldText('selectDrink'.tr, 14.0, AppColors.blackColor, TextAlign.start),
        ),
        for (int i = 0; i < widget.drinks!.length; i++)
          Obx(() => InkWell(
                onTap: () {
                  drinkValue.value = i;
                },
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      child: Radio(
                        value: i,
                        groupValue: drinkValue.value,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          drinkValue.value = int.parse(value.toString());
                          drinkName.value = widget.drinks![int.parse(value.toString())];
                          widget.function!(drinkName.value);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: utils.poppinsRegularText(widget.drinks![i], 12.0, AppColors.blackColor, TextAlign.start),
                    ),
                  ],
                ),
              )),
      ],
    );
  }
}
