import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/models/add_variations_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/add_variations_widget.dart';

class AddVariationsWidgetProvider with ChangeNotifier {
  Utils utils = new Utils();

  List<AddVariationsModel> widgets = [AddVariationsModel(AddVariationsWidget(TextEditingController(),TextEditingController(), 0), 0)];

  List<AddVariationsModel> getWidgets() => widgets;

  void addNewWidget() {
    widgets.add(AddVariationsModel(AddVariationsWidget(TextEditingController(),TextEditingController(), widgets.length), widgets.length));
    notifyListeners();
  }

  void addFirstWidget() {
    widgets.add(AddVariationsModel(AddVariationsWidget(TextEditingController(),TextEditingController(), 0), 0));
  }

  void decrementWidget(int index) {
    var item = widgets.where((element) => element.index == index).first;
    widgets.remove(item);
    print("removed: " + widgets.length.toString());
    notifyListeners();
  }

}
