import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/models/add_item_included_model.dart';
import 'package:foodizm_admin_app/providers/add_item_included_widget_provider.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/add_item_included_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddItemIncludedScreen extends StatefulWidget {
  const AddItemIncludedScreen({Key? key}) : super(key: key);

  @override
  _AddItemIncludedScreenState createState() => _AddItemIncludedScreenState();
}

class _AddItemIncludedScreenState extends State<AddItemIncludedScreen> {
  AddItemIncludedWidgetProvider? widgetProvider;
  Utils utils = new Utils();

  @override
  void initState() {
    // TODO: implement initState
    widgetProvider = Provider.of<AddItemIncludedWidgetProvider>(context, listen: false);
    super.initState();
    widgetProvider!.widgets.clear();
    if (Common.selectedItemIncludedList.length > 0) {
      for (int i = 0; i < Common.selectedItemIncludedList.length; i++) {
        TextEditingController titleController = new TextEditingController();
        titleController.text = Common.selectedItemIncludedList[i];
        widgetProvider!.widgets.add(AddItemIncludedModel(AddItemIncludedWidget(titleController, i), i));
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
        title: utils.poppinsMediumText('addItemsIncludedHeading'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<AddItemIncludedWidgetProvider>(builder: (context, build, child) {
                return Column(
                  children: widgetProvider!.widgets.map<Widget>((widgets) => widgets.addItemIncludedWidget).toList(),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addItemIncludedWidget.titleController.text.isNotEmpty) {
                        setState(() {
                          widgetProvider!.addNewWidget();
                        });
                      } else {
                        utils.showToast('provideItemsIncludedTitle'.tr);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 35,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Center(child: utils.poppinsMediumText('addMoreItemsIncluded'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addItemIncludedWidget.titleController.text.isNotEmpty) {
                    Common.selectedItemIncludedList.clear();
                    for (int i = 0; i < widgetProvider!.widgets.length; i++) {
                      Common.selectedItemIncludedList.add(widgetProvider!.widgets[i].addItemIncludedWidget.titleController.text);
                    }
                    Get.back();
                  } else {
                    utils.showToast('provideItemsIncludedTitle'.tr);
                  }
                },
                child: Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Center(child: utils.poppinsMediumText('selectItemsIncluded'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
