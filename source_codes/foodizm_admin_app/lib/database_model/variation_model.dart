import 'package:firebase_database/firebase_database.dart';

class VariationModel {
  String? name, price;

  VariationModel({this.name, this.price});

  VariationModel.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        price = snapshot.value["price"];

  VariationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }
}
