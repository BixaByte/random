import 'package:firebase_database/firebase_database.dart';

class AddressesModel {
  String? address, lat, lng, title, status,zipCode;

  AddressesModel({this.address, this.lat, this.lng, this.title, this.status,this.zipCode});

  AddressesModel.fromSnapshot(DataSnapshot snapshot)
      : address = snapshot.value["address"],
        lat = snapshot.value["lat"],
        lng = snapshot.value["lng"],
        title = snapshot.value["title"],
        status = snapshot.value["status"],
        zipCode = snapshot.value["zipCode"];

  AddressesModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    title = json['title'];
    status = json['status'];
    zipCode = json['zipCode'];
  }
}
