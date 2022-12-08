import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodizm_driver_app/colors.dart';
import 'package:foodizm_driver_app/common/common.dart';
import 'package:foodizm_driver_app/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';

class Utils {
  boxDecoration(color, borderColor) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(10),
    );
  }

  inputDecoration(text) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 14),
      hintText: text,
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(15),
    );
  }

  inputDecorationWithLabel(hint, labelText, fillColor, color, {image, onTap}) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 14, color: AppColors.lightGreyColor, height: 1.5, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      hintText: hint,
      labelStyle: TextStyle(fontSize: 14, color: AppColors.primaryColor, height: 1, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      labelText: labelText,
      filled: true,
      alignLabelWithHint: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.primaryColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color)),
      suffixIcon: image != null
          ? InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(image, color: AppColors.blackColor, height: 20, width: 20),
              ),
            )
          : null,
    );
  }

  gradient(color1, color2, circularValue) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(circularValue),
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color1, color2]),
    );
  }

  poppinsSemiBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
    );
  }

  poppinsRegularText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.normal),
    );
  }

  poppinsBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w900),
    );
  }

  poppinsMediumText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
    );
  }

  helveticaBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
    );
  }

  helveticaMediumText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Helvetica', fontWeight: FontWeight.normal),
    );
  }

  helveticaSemiBoldText(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Helvetica', fontWeight: FontWeight.w500),
    );
  }

  helveticaSemiBold2Lines(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(height: 1.1, color: color, fontSize: size, fontFamily: 'Helvetica', fontWeight: FontWeight.w500),
    );
  }

  poppinsRegularTextLineTrough(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.normal, decoration: TextDecoration.lineThrough),
    );
  }

  poppinsMediumText1Lines(text, size, color, textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: size, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
    );
  }

  showToast(text) {
    return Fluttertoast.showToast(msg: "" + text, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, fontSize: 16.0);
  }

  showLoadingDialog() {
    Get.dialog(
      Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor)),
      barrierDismissible: false,
      useSafeArea: true,
    );
  }

  noDataWidget(text, height) {
    return Container(
      height: height,
      child: Center(
        child: Text(
          text,
          softWrap: false,
          style: TextStyle(color: AppColors.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void getUserCurrentLocation(String origin) async {
    bool serviceEnabled = await Common.location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Common.location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await Common.location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await Common.location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await Common.location.getLocation();

    Common.currentLat = locationData.latitude.toString();
    Common.currentLng = locationData.longitude.toString();

    Common.locationStream = Common.location.onLocationChanged.listen((LocationData currentLocation) {
      Common.currentLat = currentLocation.latitude.toString();
      Common.currentLng = currentLocation.longitude.toString();
      addDriverLocation();
    });

    if (origin == 'location') {
      Get.offAll(() => HomeScreen());
    }
  }

  addDriverLocation() async {
    var databaseReference = FirebaseDatabase.instance.reference();
    String uid = Utils().getUserId();
    await databaseReference.child('Online Drivers').child(uid).once().then((DataSnapshot dataSnapshot) async {
      if (dataSnapshot.exists) {
        await databaseReference.child('Online Drivers').child(uid).update({'currentLat': Common.currentLat, 'currentLng': Common.currentLng});
      } else {
        await databaseReference.child('Online Drivers').child(uid).update({
          'currentLat': Common.currentLat,
          'currentLng': Common.currentLng,
          'uid': uid,
        });
        await databaseReference.child('Drivers').child(uid).update({'onlineStatus': 'free'});
      }
    });
  }

  driverOfflineMethod() async {
    var databaseReference = FirebaseDatabase.instance.reference();
    String uid = Utils().getUserId();
    await databaseReference.child('Drivers').child(uid).update({'onlineStatus': 'Offline'});
    await databaseReference.child('Online Drivers').child(uid).once().then((DataSnapshot dataSnapshot) async {
      if (dataSnapshot.exists) {
        await databaseReference.child('Online Drivers').child(uid).remove();
      }
    });
  }

  getUserId() {
    var credentials = Hive.box('credentials');
    return credentials.get('uid');
  }
}
