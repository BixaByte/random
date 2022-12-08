import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? uid, email, fullName, userName, profilePicture, phoneNumber, gender, dateOfBirth, userToken;
  String? address, latitude, longitude;

  UserModel({
    this.uid,
    this.email,
    this.fullName,
    this.userName,
    this.profilePicture,
    this.phoneNumber,
    this.gender,
    this.address,
    this.latitude,
    this.dateOfBirth,
    this.userToken,
    this.longitude,
  });

  UserModel.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.value["uid"],
        email = snapshot.value["email"],
        fullName = snapshot.value["fullName"],
        userName = snapshot.value["userName"],
        profilePicture = snapshot.value["profilePicture"],
        phoneNumber = snapshot.value["phoneNumber"],
        gender = snapshot.value["gender"],
        address = snapshot.value["address"],
        latitude = snapshot.value["latitude"],
        longitude = snapshot.value["longitude"],
        dateOfBirth = snapshot.value["date_of_birth"],
        userToken = snapshot.value["userToken"];

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    fullName = json['fullName'];
    userName = json['userName'];
    profilePicture = json['profilePicture'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    gender = json['gender'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    dateOfBirth = json['date_of_birth'];
    userToken = json['userToken'];
  }
}
