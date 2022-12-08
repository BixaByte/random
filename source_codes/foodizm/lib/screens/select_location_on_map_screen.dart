import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectLocationOnMapScreen extends StatefulWidget {
  @override
  _SelectLocationOnMapScreenState createState() => _SelectLocationOnMapScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SelectLocationOnMapScreenState extends State<SelectLocationOnMapScreen> {
  Utils utils = new Utils();
  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = Set();
  double? lat, lng;
  String? address, city;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: utils.poppinsMediumText('selectLocations'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        actions: [],
      ),
      key: homeScaffoldKey,
      body: Stack(
        children: [
          GoogleMap(
            compassEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(target: LatLng(0.0, 0.0), zoom: 17),
            zoomControlsEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            markers: markers,
            onTap: (LatLng pos) {
              setState(() {
                lat = pos.latitude;
                lng = pos.longitude;
                markers.add(Marker(
                  markerId: MarkerId("newLocation"),
                  position: pos,
                ));
              });
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                    textStyle: TextStyle(color: AppColors.accentColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    _handlePressButton();
                  },
                  child: Text("search".tr),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primaryColor,
                    textStyle: TextStyle(color: AppColors.accentColor, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    getAddress();
                  },
                  child: Text("confirm".tr),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 80,
            child: InkWell(
              onTap: () => getUserCurrentLocation(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle,color: AppColors.primaryColor),
                child: Icon(Icons.my_location_outlined,color: AppColors.whiteColor)
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getAddress() async {
    var addresses = await GeoCode().reverseGeocoding(latitude: lat!, longitude: lng!);
    Get.back(result: [addresses.streetAddress, lat.toString(), lng.toString(), addresses.city, addresses.postal]);
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController.complete(controller);
    });
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Common.apiKey!,
      onError: onError,
      mode: Mode.overlay,
      language: "en-us",
      types: [""],
      strictbounds: false,
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "pk"), Component(Component.country, "in")],
    );

    displayPrediction(p!, homeScaffoldKey.currentState!);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: Common.apiKey!,
      apiHeaders: await GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId.toString());
    lat = detail.result.geometry!.location.lat;
    lng = detail.result.geometry!.location.lng;
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat!, lng!), zoom: 17)));
    setState(() {
      markers.add(Marker(markerId: MarkerId("newLocation"), position: LatLng(lat!, lng!)));
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage.toString())),
    );
  }

  void getUserCurrentLocation() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      await Geolocator.getCurrentPosition().then((value) async {
        final GoogleMapController controller = await mapController.future;
        setState(() {
          controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(value.latitude, value.longitude), zoom: 17)));
          markers.add(Marker(markerId: MarkerId("newLocation"), position: LatLng(value.latitude, value.longitude)));
          lat = value.latitude;
          lng = value.longitude;
        });
      });
    } else {
      utils.showToast('needAllow'.tr);
    }
  }
}
