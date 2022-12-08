import 'package:firebase_database/firebase_database.dart';

class OnlineDriverModel {
  String? currentLat, currentLng, uid;

  OnlineDriverModel({this.currentLat, this.currentLng, this.uid});

  OnlineDriverModel.fromSnapshot(DataSnapshot snapshot)
      : currentLat = snapshot.value["currentLat"],
        currentLng = snapshot.value["currentLng"],
        uid = snapshot.value["uid"];

  OnlineDriverModel.fromJson(Map<String, dynamic> json) {
    currentLat = json['currentLat'];
    currentLng = json['currentLng'];
    uid = json['uid'];
  }
}
