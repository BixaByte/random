import 'package:firebase_database/firebase_database.dart';

class ChargesModel {
  String? freeDeliveryRadius, maxRadius, deliveryFeePerKm, taxes;

  ChargesModel({this.freeDeliveryRadius, this.maxRadius, this.deliveryFeePerKm, this.taxes});

  ChargesModel.fromSnapshot(DataSnapshot snapshot)
      : freeDeliveryRadius = snapshot.value["freeDeliveryRadius"].toString(),
        maxRadius = snapshot.value["maxRadius"].toString(),
        deliveryFeePerKm = snapshot.value["deliveryFeePerKm"].toString(),
        taxes = snapshot.value["taxes"].toString();

  ChargesModel.fromJson(Map<String, dynamic> json) {
    freeDeliveryRadius = json['freeDeliveryRadius'].toString();
    maxRadius = json['maxRadius'].toString();
    deliveryFeePerKm = json['deliveryFeePerKm'].toString();
    taxes = json['taxes'].toString();
  }
}
