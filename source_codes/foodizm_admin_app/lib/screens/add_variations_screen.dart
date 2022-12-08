import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/models/add_variations_model.dart';
import 'package:foodizm_admin_app/models/selected_variation_model.dart';
import 'package:foodizm_admin_app/providers/add_variations_widget_provider.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/add_variations_widget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddVariationsScreen extends StatefulWidget {
  const AddVariationsScreen({Key? key}) : super(key: key);

  @override
  _AddVariationsScreenState createState() => _AddVariationsScreenState();
}

class _AddVariationsScreenState extends State<AddVariationsScreen> {
  AddVariationsWidgetProvider? widgetProvider;
  Utils utils = new Utils();

  @override
  void initState() {
    // TODO: implement initState
    widgetProvider = Provider.of<AddVariationsWidgetProvider>(context, listen: false);
    super.initState();
    widgetProvider!.widgets.clear();
    if (Common.selectedVariationsList.length > 0) {
      for (int i = 0; i < Common.selectedVariationsList.length; i++) {
        TextEditingController titleController = new TextEditingController();
        titleController.text = Common.selectedVariationsList[i].title;
        TextEditingController priceController = new TextEditingController();
        priceController.text = Common.selectedVariationsList[i].price;
        widgetProvider!.widgets.add(AddVariationsModel(AddVariationsWidget(titleController, priceController, i), i));
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
        title: utils.poppinsMediumText('addVariationsHeading'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<AddVariationsWidgetProvider>(builder: (context, build, child) {
                return Column(
                  children: widgetProvider!.widgets.map<Widget>((widgets) => widgets.addVariationsWidget).toList(),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addVariationsWidget.titleController.text.isNotEmpty) {
                        if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addVariationsWidget.priceController.text.isNotEmpty) {
                          setState(() {
                            widgetProvider!.addNewWidget();
                          });
                        } else {
                          utils.showToast('provideVariationPrice'.tr);
                        }
                      } else {
                        utils.showToast('provideVariationTitle'.tr);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 35,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Center(child: utils.poppinsMediumText('addMoreVariation'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addVariationsWidget.titleController.text.isNotEmpty) {
                    if (widgetProvider!.widgets[widgetProvider!.widgets.length - 1].addVariationsWidget.priceController.text.isNotEmpty) {
                      Common.selectedVariationsList.clear();
                      for (int i = 0; i < widgetProvider!.widgets.length; i++) {
                        Common.selectedVariationsList.add(SelectedVariationsModel(widgetProvider!.widgets[i].addVariationsWidget.titleController.text,
                            widgetProvider!.widgets[i].addVariationsWidget.priceController.text));
                      }
                      Get.back();
                    } else {
                      utils.showToast('provideVariationPrice'.tr);
                    }
                  } else {
                    utils.showToast('provideVariationTitle'.tr);
                  }
                },
                child: Container(
                  height: 45,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Center(child: utils.poppinsMediumText('selectVariation'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
