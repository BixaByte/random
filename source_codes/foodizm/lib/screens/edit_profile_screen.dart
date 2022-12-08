import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/user_model.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Utils utils = new Utils();
  Rx<File> profileImage = File('').obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  var databaseReference = FirebaseDatabase.instance.reference();
  var userNameController = new TextEditingController();
  var phoneNumberController = new TextEditingController();
  var emailController = new TextEditingController();
  var fullNameController = new TextEditingController();
  var dobController = new TextEditingController().obs;
  RxInt genderIndex = 0.obs;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController.text = Common.userModel.userName!;
    phoneNumberController.text = Common.userModel.phoneNumber!;
    emailController.text = Common.userModel.email!;
    fullNameController.text = Common.userModel.fullName!;
    dobController.value.text = Common.userModel.dateOfBirth!;

    if (Common.userModel.gender == 'male'.tr) {
      genderIndex.value = 0;
    } else {
      genderIndex.value = 1;
    }
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
        title: utils.poppinsMediumText('myProfile'.tr, 16.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [],
      ),
      body: Obx(() {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  utils.poppinsSemiBoldText('editProfile'.tr, 25.0, AppColors.primaryColor, TextAlign.center),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: storagePermission,
                          child: Container(
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
                                        ? Common.userModel.profilePicture == 'default'
                                            ? Image.asset("assets/images/male_place.png", fit: BoxFit.cover)
                                            : CachedNetworkImage(
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                                imageUrl: Common.userModel.profilePicture!,
                                                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                ),
                                                errorWidget: (context, url, error) => Image.asset("assets/images/male_place.png", fit: BoxFit.cover),
                                              )
                                        : Image.file(profileImage.value, width: 100, height: 100, fit: BoxFit.cover),
                                  ),
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
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: userNameController,
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            decoration: utils.inputDecorationWithLabel('userNameEg'.tr, 'userName'.tr, AppColors.lightGrey2Color),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: phoneNumberController,
                            keyboardType: TextInputType.number,
                            readOnly: true,
                            decoration: utils.inputDecorationWithLabel('phoneEg'.tr, 'phoneNumber'.tr, AppColors.lightGrey2Color),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                            decoration: utils.inputDecorationWithLabel('emailEg'.tr, 'email'.tr, AppColors.lightGrey2Color),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            controller: fullNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: utils.inputDecorationWithLabel('fullName'.tr, 'fullName'.tr, AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enterFullName".tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        utils.poppinsRegularText('chooseGender'.tr, 18.0, AppColors.primaryColor, TextAlign.center),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    genderIndex.value = 0;
                                  },
                                  child: Container(
                                    height: 100,
                                    child: buildBox(0, 'male'.tr, 'assets/images/male.svg'),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    genderIndex.value = 1;
                                  },
                                  child: Container(
                                    height: 100,
                                    child: buildBox(1, 'female'.tr, 'assets/images/female.svg'),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: TextFormField(
                            controller: dobController.value,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: AppColors.primaryColor,
                                        onPrimary: AppColors.whiteColor,
                                        surface: AppColors.whiteColor,
                                        onSurface: AppColors.primaryColor,
                                      ),
                                      dialogBackgroundColor: AppColors.whiteColor,
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              dobController.value.text = DateFormat("dd-MMM-yyyy").format(pickedDate!);
                            },
                            decoration: utils.inputDecorationWithLabel('dobEg'.tr, 'dob'.tr, AppColors.lightGrey2Color),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "selectDob".tr;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        if (genderIndex.value != 3) {
                          if (profileImage.value.path != '') {
                            utils.showLoadingDialog();
                            uploadWithImage();
                          } else {
                            utils.showLoadingDialog();
                            uploadWithoutImage();
                          }
                        } else {
                          utils.showToast('pleaseChooseGender'.tr);
                        }
                      }
                    },
                    child: Container(
                      height: 40,
                      width: Get.width,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      child: Center(child: utils.poppinsMediumText('update'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  buildBox(index, text, icon) {
    return Card(
      color: genderIndex.value == index ? AppColors.primaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.primaryColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == 'female'.tr)
            Transform.rotate(
              angle: 90 * math.pi / 21,
              child: SvgPicture.asset(icon, height: 20, width: 20, color: genderIndex.value == index ? AppColors.whiteColor : AppColors.primaryColor),
            ),
          if (text == 'male'.tr)
            SvgPicture.asset(icon, height: 20, width: 20, color: genderIndex.value == index ? AppColors.whiteColor : AppColors.primaryColor),
          utils.poppinsRegularText(text, 18.0, genderIndex.value == index ? AppColors.whiteColor : AppColors.primaryColor, TextAlign.center)
        ],
      ),
    );
  }

  _imgFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    profileImage.value = await cropImage(File(pickedFile!.path));
    setState(() {});
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
      Utils().showToast('needAllow'.tr);
    }
  }

  uploadWithImage() async {
    print(p.extension(profileImage.value.path));
    Reference ref =
        storage.ref().child("UsersProfilePicture/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(profileImage.value.path));
    UploadTask uploadTask = ref.putFile(File(profileImage.value.path));
    final TaskSnapshot downloadUrl = (await uploadTask);
    String url = await downloadUrl.ref.getDownloadURL();

    Map<String, dynamic> value = {
      'profilePicture': url,
      'userName': userNameController.text,
      'gender': genderIndex.value == 0 ? 'male'.tr : 'female'.tr,
      'date_of_birth': dobController.value.text,
      'fullName': fullNameController.text,
      'phoneNumber': phoneNumberController.text,
      'email': emailController.text,
    };

    databaseReference.child('Users').child(Utils().getUserId()).update(value).whenComplete(() {
      saveUser(Utils().getUserId());
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }

  uploadWithoutImage() async {
    Map<String, dynamic> value = {
      'userName': userNameController.text,
      'gender': genderIndex.value == 0 ? 'male'.tr : 'female'.tr,
      'date_of_birth': dobController.value.text,
      'fullName': fullNameController.text,
      'phoneNumber': phoneNumberController.text,
      'email': emailController.text,
    };
    databaseReference.child('Users').child(Utils().getUserId()).update(value).whenComplete(() async {
      await databaseReference.child('UsersName').push().set({'userName': userNameController.text});
      saveUser(Utils().getUserId());
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }

  saveUser(String uid) {
    Query query = databaseReference.child('Users').child(uid);
    query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Get.back();
        Get.back();
        Common.userModel = UserModel.fromJson(Map.from(snapshot.value));
        Utils().showToast('profileUpdated'.tr);
      } else {
        Get.back();
        Utils().showToast('noUserFound'.tr);
      }
    });
  }
}
