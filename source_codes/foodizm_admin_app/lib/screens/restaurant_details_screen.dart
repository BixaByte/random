import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodizm_admin_app/database_model/restaurant_details_model.dart';
import 'package:foodizm_admin_app/screens/select_location_on_map_screen.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({Key? key}) : super(key: key);

  @override
  _RestaurantDetailsScreenState createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  Utils utils = new Utils();
  Rx<File> profileImage = File('').obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  var databaseReference = FirebaseDatabase.instance.reference();
  var restaurantNameController = new TextEditingController();
  var restaurantPhoneController = new TextEditingController();
  var restaurantAddressController = new TextEditingController();
  String? lat, lng;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    restaurantNameController.text = Common.restaurantDetails.value.name!;
    restaurantPhoneController.text = Common.restaurantDetails.value.phoneNumber!;
    restaurantAddressController.text = Common.restaurantDetails.value.address!;
    lat = Common.restaurantDetails.value.lat!;
    lng = Common.restaurantDetails.value.lng!;
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
        title: utils.poppinsMediumText('Restaurant Details', 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: Obx(() => SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    utils.poppinsSemiBoldText('Edit your restaurant detail', 20.0, AppColors.primaryColor, TextAlign.center),
                    InkWell(
                      onTap: storagePermission,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30, bottom: 10),
                              child: Container(
                                decoration: new BoxDecoration(
                                    color: AppColors.whiteColor, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryColor)),
                                height: 125,
                                width: 125,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                      child: profileImage.value.path == ""
                                          ? Common.restaurantDetails.value.logo == 'default'
                                              ? SvgPicture.asset('assets/images/add_photo.svg', fit: BoxFit.cover)
                                              : CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: Common.restaurantDetails.value.logo!,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                  ),
                                                  errorWidget: (context, url, error) =>
                                                      SvgPicture.asset('assets/images/add_photo.svg', fit: BoxFit.cover),
                                                )
                                          : Image.file(profileImage.value, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                child: SvgPicture.asset('assets/images/add_icon.svg'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: restaurantNameController,
                              keyboardType: TextInputType.text,
                              decoration: utils.inputDecorationWithLabel(
                                  'Enter Restaurant Name', 'Restaurant Name', AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Restaurant Name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: restaurantPhoneController,
                              keyboardType: TextInputType.number,
                              decoration: utils.inputDecorationWithLabel(
                                  'Enter Restaurant Phone', 'Restaurant Phone', AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Restaurant Phone';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: restaurantAddressController,
                              readOnly: true,
                              minLines: 1,
                              maxLines: 5,
                              onTap: selectLocationOnMap,
                              decoration: utils.inputDecorationWithLabel(
                                  'Select Restaurant Address', 'Restaurant Address', AppColors.whiteColor, AppColors.primaryColor),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Select Address';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (profileImage.value.path != '') {
                            utils.showLoadingDialog();
                            uploadWithImage();
                          } else {
                            utils.showLoadingDialog();
                            uploadWithoutImage();
                          }
                        }
                      },
                      child: Container(
                        height: 40,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          border: Border.all(color: AppColors.primaryColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        child: Center(child: utils.poppinsMediumText('Update', 16.0, AppColors.whiteColor, TextAlign.center)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void selectLocationOnMap() async {
    var result = await Get.to(() => SelectLocationOnMapScreen());
    if (result != null) {
      restaurantAddressController.text = result[0];
      lat = result[1];
      lng = result[2];
      print("Selected " + result.toString());
    }
    setState(() {});
  }

  _imgFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    profileImage.value = await cropImage(File(pickedFile!.path));
  }

  cropImage(File pickedFile) async {
    var _image = File(pickedFile.path);
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image.path,
        maxHeight: 512,
        maxWidth: 512,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0));
    return croppedFile;
  }

  storagePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _imgFromGallery();
    } else {
      Utils().showToast('You need to allow permission in order to continue');
    }
  }

  uploadWithImage() async {
    print(p.extension(profileImage.value.path));
    Reference ref =
        storage.ref().child("RestaurantLogo/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(profileImage.value.path));
    UploadTask uploadTask = ref.putFile(File(profileImage.value.path));
    final TaskSnapshot downloadUrl = (await uploadTask);
    String url = await downloadUrl.ref.getDownloadURL();

    Map<String, dynamic> value = {
      'logo': url,
      'name': restaurantNameController.text,
      'phoneNumber': restaurantPhoneController.text,
      'address': restaurantAddressController.text,
      'lat': lat,
      'lng': lng,
    };

    databaseReference.child('RestaurantDetails').update(value).whenComplete(() {
      saveDataInModel();
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }

  uploadWithoutImage() async {
    Map<String, dynamic> value = {
      'name': restaurantNameController.text,
      'phoneNumber': restaurantPhoneController.text,
      'address': restaurantAddressController.text,
      'lat': lat,
      'lng': lng,
    };
    databaseReference.child('RestaurantDetails').update(value).whenComplete(() async {
      saveDataInModel();
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }

  saveDataInModel() {
    Query query = databaseReference.child('RestaurantDetails');
    query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Get.back();
        Get.back();
        Common.restaurantDetails.value = RestaurantDetailsModel.fromJson(Map.from(snapshot.value));
        Utils().showToast('Data Updated Successfully');
      } else {
        Get.back();
        Utils().showToast('No restaurant found');
      }
    });
  }
}
