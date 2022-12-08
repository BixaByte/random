import 'package:firebase_database/firebase_database.dart';

class RestaurantDetailsModel {
  String? name, logo, address, lat, lng, phoneNumber;

  RestaurantDetailsModel({this.name, this.logo, this.address, this.lat, this.lng, this.phoneNumber});

  RestaurantDetailsModel.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        logo = snapshot.value["logo"],
        address = snapshot.value["address"],
        lat = snapshot.value["lat"],
        lng = snapshot.value["lng"],
        phoneNumber = snapshot.value["phoneNumber"];

  RestaurantDetailsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    phoneNumber = json['phoneNumber'];
  }
}
