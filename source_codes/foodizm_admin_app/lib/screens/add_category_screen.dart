import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/database_model/categories_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/widget/show_color_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class AddCategoryScreen extends StatefulWidget {
  final String? origin;
  final CategoriesModel? categoriesModel;

  const AddCategoryScreen({Key? key, this.origin, this.categoriesModel}) : super(key: key);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  Utils utils = new Utils();
  var titleController = new TextEditingController();
  var colorController = new TextEditingController();
  Rx<File> categoryImage = File('').obs;
  Rx<File> categoryIcon = File('').obs;
  var formKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    if (widget.origin == 'edit') {
      titleController.text = widget.categoriesModel!.title!;
      colorController.text = widget.categoriesModel!.colorCode!.substring(1);
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
        title:
            utils.poppinsMediumText(widget.origin == 'add' ? 'addNewCategory'.tr : 'editCategory'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Obx(() => SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                storagePermission('image');
                              },
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 150, minHeight: 150, minWidth: double.infinity),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: AppColors.primaryColor), borderRadius: BorderRadius.circular(10.0)),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: categoryImage.value.path == ""
                                      ? widget.origin == 'edit' && widget.categoriesModel!.image != 'default'
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: widget.categoriesModel!.image!,
                                                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                ),
                                                errorWidget: (context, url, error) => Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/images/upload.png", height: 40, width: 40, color: AppColors.lightGreyColor),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 5),
                                                      child:
                                                          utils.poppinsMediumText('uploadImage'.tr, 14.0, AppColors.lightGreyColor, TextAlign.center),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/images/upload.png", height: 40, width: 40, color: AppColors.lightGreyColor),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: utils.poppinsMediumText('uploadImage'.tr, 14.0, AppColors.lightGreyColor, TextAlign.center),
                                                ),
                                              ],
                                            )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          child: Image.file(categoryImage.value, fit: BoxFit.cover),
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: utils.poppinsRegularText('image'.tr, 16.0, AppColors.blackColor, TextAlign.center),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                storagePermission('icon');
                              },
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 150, minHeight: 150, minWidth: double.infinity),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: AppColors.primaryColor), borderRadius: BorderRadius.circular(10.0)),
                                  color: Colors.transparent,
                                  elevation: 0,
                                  child: categoryIcon.value.path == ""
                                      ? widget.origin == 'edit' && widget.categoriesModel!.icon != 'default'
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: widget.categoriesModel!.icon!,
                                                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                ),
                                                errorWidget: (context, url, error) => Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset("assets/images/upload.png", height: 40, width: 40, color: AppColors.lightGreyColor),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 5),
                                                      child:
                                                          utils.poppinsMediumText('uploadIcon'.tr, 14.0, AppColors.lightGreyColor, TextAlign.center),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.asset("assets/images/upload.png", height: 40, width: 40, color: AppColors.lightGreyColor),
                                                Container(
                                                  margin: EdgeInsets.only(top: 5),
                                                  child: utils.poppinsMediumText('uploadIcon'.tr, 14.0, AppColors.lightGreyColor, TextAlign.center),
                                                ),
                                              ],
                                            )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          child: Image.file(categoryIcon.value, fit: BoxFit.cover),
                                        ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: utils.poppinsRegularText('icon'.tr, 16.0, AppColors.blackColor, TextAlign.center),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller: titleController,
                            textCapitalization: TextCapitalization.words,
                            decoration: utils.inputDecorationWithLabel('enterName'.tr, 'name'.tr, AppColors.whiteColor, AppColors.primaryColor),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterCategoryName'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Stack(
                            children: [
                              TextFormField(
                                controller: colorController,
                                readOnly: true,
                                decoration:
                                    utils.inputDecorationWithLabel('selectColor'.tr, 'color'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                onTap: () {
                                  showColorPickerDialog(context);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'pleaseChooseColor'.tr;
                                  }
                                  return null;
                                },
                              ),
                              if (colorController.text.isNotEmpty)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.only(right: 10, top: 10),
                                    color: Color(int.parse("0xFF" + colorController.text)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        if (widget.origin == 'add') {
                          if (categoryImage.value.path != '') {
                            if (categoryIcon.value.path != '') {
                              utils.showLoadingDialog();
                              addCategoryData();
                            } else {
                              utils.showToast('pleaseSelectCategoryIcon'.tr);
                            }
                          } else {
                            utils.showToast('pleaseSelectCategoryImage'.tr);
                          }
                        } else {
                          utils.showLoadingDialog();
                          updateImage();
                        }
                      }
                    },
                    child: Container(
                      height: 45,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(30.0))),
                      child: Center(child: utils.poppinsMediumText('save'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  showColorPickerDialog(context) {
    return showDialog(context: context, builder: (context) => ShowColorPicker(func: function));
  }

  function(colorCode) {
    setState(() {
      colorController.text = colorCode;
    });
  }

  addCategoryData() async {
    Reference imageRef =
        storage.ref().child("CategoriesImages/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(categoryImage.value.path));
    UploadTask uploadTaskImage = imageRef.putFile(File(categoryImage.value.path));
    final TaskSnapshot downloadUrlImage = (await uploadTaskImage);
    String urlImage = await downloadUrlImage.ref.getDownloadURL();

    Reference iconRef =
        storage.ref().child("CategoriesIcons/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(categoryIcon.value.path));
    UploadTask uploadTaskIcon = iconRef.putFile(File(categoryIcon.value.path));
    final TaskSnapshot downloadUrlIcon = (await uploadTaskIcon);
    String urlIcon = await downloadUrlIcon.ref.getDownloadURL();

    Map<String, dynamic> value = {
      'image': urlImage,
      'icon': urlIcon,
      'title': titleController.text,
      'colorCode': "#" + colorController.text,
      'timeCreated': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    databaseReference.child('Categories').push().set(value).whenComplete(() async {
      Get.back();
      Get.back();
      Utils().showToast('dataUpdated'.tr);
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }

  updateImage() async {
    String categoryImages = '';
    if (categoryImage.value.path != '') {
      String? filePathImage;
      if (Platform.isAndroid) {
        filePathImage = widget.categoriesModel!.image
            .toString()
            .replaceAll(new RegExp(r'https://firebasestorage.googleapis.com/v0/b/foodizm-flutter-bac9e.appspot.com/o/CategoriesImages%2F'), '')
            .split('?')[0];
      } else if (Platform.isIOS) {
        filePathImage = widget.categoriesModel!.image
            .toString()
            .replaceAll(new RegExp(r'https://firebasestorage.googleapis.com:443/v0/b/foodizm-flutter-bac9e.appspot.com/o/CategoriesImages%2F'), '')
            .split('?')[0];
      }

      FirebaseStorage.instance.ref().child('CategoriesImages/').child(filePathImage!).delete().then((_) async {
        Reference imageRef =
            storage.ref().child("CategoriesImages/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(categoryImage.value.path));
        UploadTask uploadTaskImage = imageRef.putFile(File(categoryImage.value.path));
        final TaskSnapshot downloadUrlImage = (await uploadTaskImage);
        categoryImages = await downloadUrlImage.ref.getDownloadURL();
        updateIcon(categoryImages);
      });
    } else {
      categoryImages = widget.categoriesModel!.image!;
      updateIcon(categoryImages);
    }
  }

  updateIcon(String imageName) async {
    String categoryIcons = '';
    if (categoryIcon.value.path != '') {
      String? filePathIcon;
      if (Platform.isAndroid) {
        filePathIcon = widget.categoriesModel!.icon
            .toString()
            .replaceAll(new RegExp(r'https://firebasestorage.googleapis.com/v0/b/foodizm-flutter-bac9e.appspot.com/o/CategoriesIcons%2F'), '')
            .split('?')[0];
      } else if (Platform.isIOS) {
        filePathIcon = widget.categoriesModel!.icon
            .toString()
            .replaceAll(new RegExp(r'https://firebasestorage.googleapis.com:443/v0/b/foodizm-flutter-bac9e.appspot.com/o/CategoriesIcons%2F'), '')
            .split('?')[0];
      }

      FirebaseStorage.instance.ref().child('CategoriesIcons/').child(filePathIcon!).delete().then((_) async {
        Reference imageRef =
            storage.ref().child("CategoriesIcons/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(categoryIcon.value.path));
        UploadTask uploadTaskImage = imageRef.putFile(File(categoryIcon.value.path));
        final TaskSnapshot downloadUrlImage = (await uploadTaskImage);
        categoryIcons = await downloadUrlImage.ref.getDownloadURL();
        updateData(imageName, categoryIcons);
      });
    } else {
      categoryIcons = widget.categoriesModel!.icon!;
      updateData(imageName, categoryIcons);
    }
  }

  updateData(String categoryImage, String categoryIcon) async {
    Map<String, dynamic> data = {
      'image': categoryImage,
      'icon': categoryIcon,
      'title': titleController.text,
      'colorCode': "#" + colorController.text,
    };

    Query query = databaseReference.child('Categories').orderByChild('timeCreated').equalTo(widget.categoriesModel!.timeCreated!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Categories').child(value.toString()).update(data);
          Get.back();
          Get.back();
          Utils().showToast('dataUpdated'.tr);
        });
      }
    });
  }

  _imgFromGallery(String name) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (name == 'image') {
      categoryImage.value = File(pickedFile!.path);
    } else {
      categoryIcon.value = File(pickedFile!.path);
    }
  }

  storagePermission(String name) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _imgFromGallery(name);
    } else {
      Utils().showToast('needAllow'.tr);
    }
  }
}
