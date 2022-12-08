import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/providers/add_ingredients_widget_provider.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:provider/provider.dart';

class AddIngredientsWidget extends StatefulWidget {
  final int index;
  final TextEditingController titleController;

  AddIngredientsWidget(this.titleController, this.index);

  @override
  _AddIngredientsWidgetState createState() => _AddIngredientsWidgetState();
}

class _AddIngredientsWidgetState extends State<AddIngredientsWidget> {
  Utils utils = new Utils();

  AddIngredientsWidgetProvider? widgetProvider;

  @override
  void initState() {
    // TODO: implement initState
    widgetProvider = Provider.of<AddIngredientsWidgetProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddIngredientsWidgetProvider>(builder: (context, build, child) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: widget.titleController,
              textCapitalization: TextCapitalization.words,
              decoration: utils.inputDecorationWithLabel('Enter Ingredients', 'Ingredients', AppColors.whiteColor, AppColors.primaryColor),
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
