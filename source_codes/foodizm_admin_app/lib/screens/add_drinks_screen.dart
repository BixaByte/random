import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/models/add_drinks_model.dart';
import 'package:foodizm_admin_app/providers/add_drinks_widget_provider.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/add_drinks_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddDrinksScreen extends StatefulWidget {
  const AddDrinksScreen({Key? key}) : super(key: key);

  @override
  _AddDrinksScreenState createState() => _AddDrinksScreenState();
}

class _AddDrinksScreenState extends State<AddDrinksScreen> {
  AddDrinksWidgetProvider? widgetProvider;
  Utils utils = new Utils();

  @override
  void initState() {
    // TODO: implement initState
    widgetProvider = Provider.of<AddDrinksWidgetProvider>(context, listen: false);
    super.initState();
    widgetProvider!.widgets.clear();
    if (Common.selectedDrinksList.length > 0) {
      for (int i = 0; i < Common.selectedDrinksList.length; i++) {
        TextEditingController titleController = new TextEditingController();
        titleController.text = Common.selectedDrinksList[i];
        widgetProvider!.widgets.add(AddDrinksModel(AddDrinksWidget(titleController, i), i));
      }
    } else {
      widgetProvider!.addFirstWidget();
    }
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
        title: utils.poppinsMediumText('addDrinksHeading'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<AddDrinksWidgetProvider>(builder: (context, build, child) {
                return Column(
                  children: widgetProvider!.widgets.map<Widget>((widgets) => widgets.addDrinksWidget).toList(),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addDrinksWidget.titleController.text.isNotEmpty) {
                        setState(() {
                          widgetProvider!.addNewWidget();
                        });
                      } else {
                        utils.showToast('provideDrinkTitle'.tr);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 35,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Center(child: utils.poppinsMediumText('addMoreDrinks'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addDrinksWidget.titleController.text.isNotEmpty) {
                    Common.selectedDrinksList.clear();
                    for (int i = 0; i < widgetProvider!.widgets.length; i++) {
                      Common.selectedDrinksList.add(widgetProvider!.widgets[i].addDrinksWidget.titleController.text);
                    }
                    Get.back();
                  } else {
                    utils.showToast('provideDrinkTitle'.tr);
                  }
                },
                child: Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Center(child: utils.poppinsMediumText('selectDrinks'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
