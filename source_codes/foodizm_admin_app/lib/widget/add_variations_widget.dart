import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/providers/add_variations_widget_provider.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:provider/provider.dart';

class AddVariationsWidget extends StatefulWidget {
  final int index;
  final TextEditingController titleController;
  final TextEditingController priceController;

  AddVariationsWidget(this.titleController, this.priceController, this.index);

  @override
  _AddVariationsWidgetState createState() => _AddVariationsWidgetState();
}

class _AddVariationsWidgetState extends State<AddVariationsWidget> {
  Utils utils = new Utils();

  AddVariationsWidgetProvider? widgetProvider;
  
  @override
  void initState() {
    // TODO: implement initState

    widgetProvider = Provider.of<AddVariationsWidgetProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddVariationsWidgetProvider>(builder: (context, build, child) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    /*Title for this item*/
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        child: TextFormField(
                          controller: widget.titleController,
                          textCapitalization: TextCapitalization.words,
                          decoration: utils.inputDecorationWithLabel('Enter Title', 'Title', AppColors.whiteColor, AppColors.primaryColor),
                        ),
                      ),
                    ),

                    /*Price for this item*/
                    Expanded(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: TextFormField(
                          controller: widget.priceController,
                          keyboardType: TextInputType.number,
                          decoration: utils.inputDecorationWithLabel('Enter Price', 'Price', AppColors.whiteColor, AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widgetProvider!.widgets.length > 1)

            /*Remove button*/
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      widgetProvider!.decrementWidget(widget.index);
                    });
                  },
                  child: Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Center(child: utils.poppinsMediumText('Remove', 16.0, AppColors.whiteColor, TextAlign.center)),
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }
}
