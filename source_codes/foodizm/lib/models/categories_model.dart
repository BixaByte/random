import 'package:firebase_database/firebase_database.dart';

class CategoriesModel {
  String? colorCode, icon, image, title,timeCreated;
  int? viewsCount;

  CategoriesModel({this.colorCode, this.icon, this.image, this.title,this.timeCreated, this.viewsCount});

  CategoriesModel.fromSnapshot(DataSnapshot snapshot)
      : colorCode = snapshot.value["colorCode"],
        icon = snapshot.value["icon"],
        image = snapshot.value["image"],
        title = snapshot.value["title"],
        timeCreated = snapshot.value["timeCreated"],
        viewsCount = snapshot.value["viewsCount"];

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    colorCode = json['colorCode'];
    icon = json['icon'];
    image = json['image'];
    title = json['title'];
    timeCreated = json['timeCreated'];
    viewsCount = json['viewsCount'];
  }
}
