import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/driver_model.dart';
import 'package:foodizm/models/online_driver_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackOrderScreen extends StatefulWidget {
  final String? driverId, dropOffLocation;

  const TrackOrderScreen({Key? key, this.driverId, this.dropOffLocation}) : super(key: key);

  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  Utils utils = new Utils();

  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = Set();
  Set<Polyline> polyLines = Set();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  LatLng myLocation = LatLng(0.0, 0.0);
  PointLatLng myPointLocation = PointLatLng(0.0, 0.0);
  Rx<LatLng> driverLocation = LatLng(0.0, 0.0).obs;
  Rx<PointLatLng> driverPointLocation = PointLatLng(0.0, 0.0).obs;

  Rx<DriverModel> driverModel = new DriverModel().obs;
  Rx<OnlineDriverModel> onlineDriver = new OnlineDriverModel().obs;
  RxBool hasData = false.obs;
  var databaseReference = FirebaseDatabase.instance.reference();

  late StreamSubscription onChildAdded;

  RxString duration = ''.obs;

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
  }

  @override
  void dispose() {
    onChildAdded.cancel();
    super.dispose();
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController.complete(controller);
    });
  }

  void getUserCurrentLocation() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      await Geolocator.getCurrentPosition().then((value) async {
        final GoogleMapController controller = await mapController.future;
        setState(() {
          controller.animateCamera(
              CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 12, bearing: 30, tilt: 0)));
          myLocation = LatLng(value.latitude, value.longitude);
          myPointLocation = PointLatLng(value.latitude, value.longitude);
          if (widget.driverId != null) {
            getDriverData();
            trackingDriver();
          }
        });
      });
    } else {
      utils.showToast('needAllow'.tr);
    }
  }

  getDriverData() async {
    Query query = databaseReference.child('Drivers').child(widget.driverId!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        driverModel.value = DriverModel.fromJson(Map.from(snapshot.value));
      }
      hasData.value = true;
    });
  }

  trackingDriver() async {
    onChildAdded = databaseReference.child('Online Drivers').child(widget.driverId!).onValue.listen((event) {
      if (event.snapshot.value != null) {
        print("Value 1: " + event.snapshot.value.toString());
        onlineDriver.value = OnlineDriverModel.fromJson(Map.from(event.snapshot.value));
        driverLocation.value = LatLng(double.parse(onlineDriver.value.currentLat!), double.parse(onlineDriver.value.currentLng!));
        driverPointLocation.value = PointLatLng(double.parse(onlineDriver.value.currentLat!), double.parse(onlineDriver.value.currentLng!));
        setMapPins();
        setPolyLines();
      }
    });
  }

  setMapPins() {
    markers.clear();
    setState(() {
      markers.add(Marker(markerId: MarkerId('myLocation'), position: myLocation));
      markers.add(Marker(markerId: MarkerId('driverLocation'), position: driverLocation.value));
    });
    print("markers" + markers.length.toString());
  }

  setPolyLines() async {
    polyLines.clear();
    polylineCoordinates.clear();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(Common.apiKey!, myPointLocation, driverPointLocation.value);
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
    setState(() {
      Polyline polyline = Polyline(polylineId: PolylineId('id'), color: AppColors.primaryColor, points: polylineCoordinates, width: 3);
      polyLines.add(polyline);
      calculateTime(myLocation.latitude, myLocation.longitude, driverLocation.value.latitude, driverLocation.value.longitude);
    });
  }

  calculateTime(lat1, lon1, lat2, lon2) async {
    Dio dio = new Dio();
    var response = await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$lat1,$lon1&destinations"
            "=$lat2,$lon2&key=" +
        Common.apiKey!);
    print(response.data.toString());
    duration.value = response.data['rows'][0]['elements'][0]['duration']['text'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: utils.poppinsMediumText('trackYourOrder'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: markers,
                polylines: polyLines,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0), zoom: 13),
                onMapCreated: onMapCreated,
              ),
            ),
            Obx(() {
              if (hasData.value) {
                return Container(
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 60,
                                width: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: driverModel.value.profileImage != 'default'
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: driverModel.value.profileImage!,
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                            height: 30,
                                            width: 30,
                                            child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                          ),
                                          errorWidget: (context, url, error) => SvgPicture.asset("assets/images/man.svg", fit: BoxFit.cover),
                                        )
                                      : SvgPicture.asset("assets/images/man.svg", fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  utils.poppinsMediumTextLineHeight(driverModel.value.fullName!, 16.0, AppColors.blackColor, TextAlign.start, 1.2),
                                  utils.poppinsMediumTextLineHeight(driverModel.value.vehicle!, 14.0, AppColors.blackColor, TextAlign.start, 1.2),
                                  utils.poppinsMediumTextLineHeight(driverModel.value.vin!, 14.0, AppColors.blackColor, TextAlign.start, 1.2),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                utils.poppinsMediumText('estimateTime'.tr, 14.0, AppColors.blackColor, TextAlign.start),
                                Obx(() => Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2),
                                      child: utils.poppinsMediumText(duration.value, 12.0, AppColors.blackColor, TextAlign.start),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          initialValue: widget.dropOffLocation!,
                          readOnly: true,
                          minLines: 1,
                          maxLines: 5,
                          decoration: utils.inputDecorationWithLabel('', 'dropOffLocation'.tr, AppColors.primaryColor),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.whiteColor),
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
