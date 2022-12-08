import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/models/add_flavours_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/add_flavours_widget.dart';

class AddFlavoursWidgetProvider with ChangeNotifier {
  Utils utils = new Utils();

  List<AddFlavoursModel> widgets = [AddFlavoursModel(AddFlavoursWidget(TextEditingController(), 0), 0)];

  List<AddFlavoursModel> getWidgets() => widgets;

  void addNewWidget() {
    widgets.add(AddFlavoursModel(AddFlavoursWidget(TextEditingController(), widgets.length), widgets.length));
    notifyListeners();
  }

  void addFirstWidget() {
    widgets.add(AddFlavoursModel(AddFlavoursWidget(TextEditingController(), 0), 0));
  }

  void decrementWidget(int index) {
    var item = widgets.where((element) => element.index == index).first;
    widgets.remove(item);
    print("removed: " + widgets.length.toString());
    notifyListeners();
  }

}
