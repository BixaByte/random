import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class SelectFlavourWidget extends StatefulWidget {
  final List<String>? flavours;
  final Function? function;

  const SelectFlavourWidget({Key? key, this.flavours, this.function}) : super(key: key);

  @override
  _SelectFlavourState createState() => _SelectFlavourState();
}

class _SelectFlavourState extends State<SelectFlavourWidget> {
  Utils utils = new Utils();
  RxInt flavourValue = 0.obs;
  RxString flavourName = ''.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flavourName.value = widget.flavours![0];
    widget.function!(flavourName.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          child: utils.poppinsSemiBoldText('selectFlavour'.tr, 14.0, AppColors.blackColor, TextAlign.start),
        ),
        for (int i = 0; i < widget.flavours!.length; i++)
          Obx(() => InkWell(
                onTap: () {
                  flavourValue.value = i;
                },
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      child: Radio(
                        value: i,
                        groupValue: flavourValue.value,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          flavourValue.value = int.parse(value.toString());
                          flavourName.value = widget.flavours![int.parse(value.toString())];
                          widget.function!(flavourName.value);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: utils.poppinsRegularText(widget.flavours![i], 12.0, AppColors.blackColor, TextAlign.start),
                    ),
                  ],
                ),
              )),
      ],
    );
  }
}
