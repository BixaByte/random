import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/models/add_drinks_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/add_drinks_widget.dart';

class AddDrinksWidgetProvider with ChangeNotifier {
  Utils utils = new Utils();

  List<AddDrinksModel> widgets = [AddDrinksModel(AddDrinksWidget(TextEditingController(), 0), 0)];

  List<AddDrinksModel> getWidgets() => widgets;

  void addNewWidget() {
    widgets.add(AddDrinksModel(AddDrinksWidget(TextEditingController(), widgets.length), widgets.length));
    notifyListeners();
  }

  void addFirstWidget() {
    widgets.add(AddDrinksModel(AddDrinksWidget(TextEditingController(), 0), 0));
  }

  void decrementWidget(int index) {
    var item = widgets.where((element) => element.index == index).first;
    widgets.remove(item);
    print("removed: " + widgets.length.toString());
    notifyListeners();
  }

}
