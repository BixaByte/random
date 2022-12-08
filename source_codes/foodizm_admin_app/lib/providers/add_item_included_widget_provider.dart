import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/models/add_item_included_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/add_item_included_widget.dart';

class AddItemIncludedWidgetProvider with ChangeNotifier {
  Utils utils = new Utils();

  List<AddItemIncludedModel> widgets = [AddItemIncludedModel(AddItemIncludedWidget(TextEditingController(), 0), 0)];

  List<AddItemIncludedModel> getWidgets() => widgets;

  void addNewWidget() {
    widgets.add(AddItemIncludedModel(AddItemIncludedWidget(TextEditingController(), widgets.length), widgets.length));
    notifyListeners();
  }

  void addFirstWidget() {
    widgets.add(AddItemIncludedModel(AddItemIncludedWidget(TextEditingController(), 0), 0));
  }

  void decrementWidget(int index) {
    var item = widgets.where((element) => element.index == index).first;
    widgets.remove(item);
    print("removed: " + widgets.length.toString());
    notifyListeners();
  }

}
