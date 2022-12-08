import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodizm_admin_app/database_model/deals_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/screens/add_drinks_screen.dart';
import 'package:foodizm_admin_app/screens/add_flavour_screen.dart';
import 'package:foodizm_admin_app/screens/add_item_included_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDealScreen extends StatefulWidget {
  final String? origin;
  final DealsModel? dealsModel;

  const AddDealScreen({Key? key, this.origin, this.dealsModel}) : super(key: key);

  @override
  _AddDealScreenState createState() => _AddDealScreenState();
}

class _AddDealScreenState extends State<AddDealScreen> {
  Utils utils = new Utils();
  var titleController = new TextEditingController();
  var newPriceController = new TextEditingController();
  var oldPriceController = new TextEditingController();
  var discountController = new TextEditingController();
  var noOfServingController = new TextEditingController();
  var descriptionController = new TextEditingController();
  Rx<TextEditingController> startDateController = new TextEditingController().obs;
  Rx<TextEditingController> endDateController = new TextEditingController().obs;
  var formKey = GlobalKey<FormState>();
  RxInt flavourValue = 1.obs;
  RxInt drinksValue = 1.obs;
  RxInt itemIncludedValue = 1.obs;
  Rx<File> productImage = File('').obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Common.selectedDrinksList.clear();
    Common.selectedFlavourList.clear();
    Common.selectedItemIncludedList.clear();

    if (widget.origin == 'edit') {
      titleController.text = widget.dealsModel!.title!;
      newPriceController.text = widget.dealsModel!.newPrice!;
      oldPriceController.text = widget.dealsModel!.oldPrice!;
      discountController.text = widget.dealsModel!.discount!;
      noOfServingController.text = widget.dealsModel!.noOfServing!;
      descriptionController.text = widget.dealsModel!.details!;
      startDateController.value.text = widget.dealsModel!.validDate!;
      endDateController.value.text = widget.dealsModel!.expiryDate!;

      if (widget.dealsModel!.customizationForFlavours![0] == 'default') {
        flavourValue.value = 0;
      } else {
        flavourValue.value = 1;
        for (int i = 0; i < widget.dealsModel!.customizationForFlavours!.length; i++) {
          Common.selectedFlavourList.add(widget.dealsModel!.customizationForFlavours![i]);
        }
      }

      if (widget.dealsModel!.customizationForDrinks![0] == 'default') {
        drinksValue.value = 0;
      } else {
        drinksValue.value = 1;
        for (int i = 0; i < widget.dealsModel!.customizationForDrinks!.length; i++) {
          Common.selectedDrinksList.add(widget.dealsModel!.customizationForDrinks![i]);
        }
      }

      if (widget.dealsModel!.itemsIncluded![0] == 'default') {
        itemIncludedValue.value = 0;
      } else {
        itemIncludedValue.value = 1;
        for (int i = 0; i < widget.dealsModel!.itemsIncluded!.length; i++) {
          Common.selectedItemIncludedList.add(widget.dealsModel!.itemsIncluded![i]);
        }
      }
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
        title: utils.poppinsMediumText(widget.origin == 'add' ? 'addNewDeal'.tr : 'editDeal'.tr, 18.0, AppColors.blackColor, TextAlign.center),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              showDeleteDialog();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image.asset('assets/images/delete.png', height: 50, width: 40),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image
              Obx(() => InkWell(
                    onTap: storagePermission,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200, minWidth: double.infinity),
                      child: Card(
                        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.primaryColor), borderRadius: BorderRadius.circular(10.0)),
                        color: Colors.transparent,
                        elevation: 0,
                        child: productImage.value.path == ""
                            ? widget.origin == 'edit' && widget.dealsModel!.image != 'default'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.dealsModel!.image!,
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
                                            child: utils.poppinsMediumText('uploadImage'.tr, 14.0, AppColors.lightGreyColor, TextAlign.center),
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
                                child: Image.file(productImage.value, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                  )),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    // Title
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: titleController,
                        textCapitalization: TextCapitalization.words,
                        decoration: utils.inputDecorationWithLabel('enterName'.tr, 'name'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterDealName'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    // New Price
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: newPriceController,
                        keyboardType: TextInputType.number,
                        decoration: utils.inputDecorationWithLabel('enterNewPrice'.tr, 'newPrice'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterDealNewPrice'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    // Old Price
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: oldPriceController,
                        keyboardType: TextInputType.number,
                        decoration: utils.inputDecorationWithLabel('enterOldPrice'.tr, 'oldPrice'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterDealOldPrice'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    // Discount
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: discountController,
                        keyboardType: TextInputType.number,
                        decoration: utils.inputDecorationWithLabel('enterDiscount'.tr, 'discount'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterDealDiscount'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    // No of Serving
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: noOfServingController,
                        keyboardType: TextInputType.number,
                        decoration: utils.inputDecorationWithLabel('enterNoOfServing'.tr, 'serving'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterNoOfServing'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    // Dates
                    Obx(() => Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: TextFormField(
                                    controller: startDateController.value,
                                    readOnly: true,
                                    onTap: () {
                                      selectDate('start');
                                    },
                                    decoration: utils.inputDecorationWithLabel(
                                        'selectStartDate'.tr, 'startDate'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'pleaseSelectDate'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: TextFormField(
                                    controller: endDateController.value,
                                    readOnly: true,
                                    onTap: () {
                                      selectDate('end');
                                    },
                                    decoration:
                                        utils.inputDecorationWithLabel('selectEndDate'.tr, 'endDate'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'pleaseSelectDate'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    // Description
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 10,
                        decoration: utils.inputDecorationWithLabel('enterDetails'.tr, 'details'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterDetails'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Drinks
              Obx(() => makeRadioButtonWidgets('productHasDrinks'.tr, 'addDrinks'.tr, drinksValue.value, drinksChange)),
              // Selected Drinks
              Obx(() => Column(
                    children: [
                      for (int i = 0; i < Common.selectedDrinksList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            initialValue: Common.selectedDrinksList[i],
                            readOnly: true,
                            decoration: utils.inputDecorationWithLabel('enterDrink'.tr, 'drink'.tr, AppColors.whiteColor, AppColors.primaryColor),
                          ),
                        ),
                    ],
                  )),
              // Flavours
              Obx(() => makeRadioButtonWidgets('productHasFlavour'.tr, 'addFlavours'.tr, flavourValue.value, flavourChange)),
              // Selected Flavours
              Obx(() => Column(
                    children: [
                      for (int i = 0; i < Common.selectedFlavourList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            initialValue: Common.selectedFlavourList[i],
                            readOnly: true,
                            decoration: utils.inputDecorationWithLabel('enterFlavour'.tr, 'flavour'.tr, AppColors.whiteColor, AppColors.primaryColor),
                          ),
                        ),
                    ],
                  )),
              // Item Included
              Obx(() => makeRadioButtonWidgets('productHasItems'.tr, 'addItems'.tr, itemIncludedValue.value, itemIncludedChange)),
              // Selected Item Included
              Obx(() => Column(
                    children: [
                      for (int i = 0; i < Common.selectedItemIncludedList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            initialValue: Common.selectedItemIncludedList[i],
                            readOnly: true,
                            decoration: utils.inputDecorationWithLabel('enterItem'.tr, 'itemIncluded'.tr, AppColors.whiteColor, AppColors.primaryColor),
                          ),
                        ),
                    ],
                  )),
              // Save
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    if (widget.origin == 'add') {
                      if (productImage.value.path != '') {
                        checkValidationForFlavour();
                      } else {
                        utils.showToast('selectDealImage'.tr);
                      }
                    } else {
                      checkValidationForFlavour();
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
        ),
      ),
    );
  }

  makeRadioButtonWidgets(title, subTitle, value, onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child: utils.poppinsMediumText(title, 14.0, AppColors.blackColor, TextAlign.start),
        ),
        Row(
          children: <Widget>[
            new Radio(value: 1, activeColor: AppColors.primaryColor, groupValue: value, onChanged: onChanged),
            new Text('yes'.tr, style: new TextStyle(fontSize: 16.0)),
            new Radio(value: 0, activeColor: AppColors.primaryColor, groupValue: value, onChanged: onChanged),
            new Text('no'.tr, style: new TextStyle(fontSize: 16.0)),
          ],
        ),
        Visibility(
          visible: value == 1 ? true : false,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                utils.poppinsMediumText(subTitle, 15.0, AppColors.blackColor, TextAlign.start),
                InkWell(
                  onTap: () {
                    if (subTitle == 'addDrinks'.tr)
                      Get.to(() => AddDrinksScreen());
                    else if (subTitle == 'addFlavours'.tr)
                      Get.to(() => AddFlavoursScreen());
                    else if (subTitle == 'addItems'.tr) Get.to(() => AddItemIncludedScreen());
                  },
                  child: SvgPicture.asset('assets/images/add.svg', height: 50, width: 50),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void flavourChange(value) {
    flavourValue.value = value;
    Common.selectedFlavourList.clear();
  }

  void drinksChange(value) {
    drinksValue.value = value;
    Common.selectedDrinksList.clear();
  }

  void itemIncludedChange(value) {
    itemIncludedValue.value = value;
    Common.selectedItemIncludedList.clear();
  }

  selectDate(String? origin) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2200),
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
        });
    if (origin == 'start')
      startDateController.value.text = DateFormat("dd-MMM-yyyy").format(pickedDate!);
    else
      endDateController.value.text = DateFormat("dd-MMM-yyyy").format(pickedDate!);
  }

  _imgFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    productImage.value = await cropImage(File(pickedFile!.path));
  }

  cropImage(File pickedFile) async {
    var _image = File(pickedFile.path);
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _image.path,
        maxHeight: 512,
        maxWidth: 512,
        cropStyle: CropStyle.rectangle,
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

  checkValidationForFlavour() {
    if (flavourValue.value == 1) {
      if (Common.selectedFlavourList.length > 0) {
        checkValidationForDrinks();
      } else {
        utils.showToast('addProductFlavour'.tr);
      }
    } else {
      checkValidationForDrinks();
    }
  }

  checkValidationForDrinks() {
    if (drinksValue.value == 1) {
      if (Common.selectedDrinksList.length > 0) {
        checkValidationForItemIncluded();
      } else {
        utils.showToast('addDealDrinks'.tr);
      }
    } else {
      checkValidationForItemIncluded();
    }
  }

  checkValidationForItemIncluded() {
    if (itemIncludedValue.value == 1) {
      if (Common.selectedItemIncludedList.length > 0) {
        utils.showLoadingDialog();
        if (widget.origin == 'add') {
          saveDeal();
        } else {
          updateImage();
        }
      } else {
        utils.showToast('addDealItemIncluded'.tr);
      }
    } else {
      utils.showLoadingDialog();
      if (widget.origin == 'add') {
        saveDeal();
      } else {
        updateImage();
      }
    }
  }

  saveDeal() async {
    List<String>? itemIncludedModel = [];
    List<String>? flavoursModel = [];
    List<String>? drinksModel = [];

    if (itemIncludedValue.value == 1) {
      for (int i = 0; i < Common.selectedItemIncludedList.length; i++) {
        itemIncludedModel.add(Common.selectedItemIncludedList[i]);
      }
    } else {
      itemIncludedModel.add('default');
    }

    if (flavourValue.value == 1) {
      for (int i = 0; i < Common.selectedFlavourList.length; i++) {
        flavoursModel.add(Common.selectedFlavourList[i]);
      }
    } else {
      flavoursModel.add('default');
    }

    if (drinksValue.value == 1) {
      for (int i = 0; i < Common.selectedDrinksList.length; i++) {
        drinksModel.add(Common.selectedDrinksList[i]);
      }
    } else {
      drinksModel.add('default');
    }

    Reference ref = storage.ref().child("DealImages/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(productImage.value.path));
    UploadTask uploadTask = ref.putFile(File(productImage.value.path));
    final TaskSnapshot downloadUrlIcon = (await uploadTask);
    String url = await downloadUrlIcon.ref.getDownloadURL();

    Map<String, dynamic> data = {
      "title": titleController.text,
      "details": descriptionController.text,
      "image": url,
      "type": 'deal',
      "no_of_serving": noOfServingController.text,
      "timeCreated": DateTime.now().millisecondsSinceEpoch.toString(),
      "newPrice": newPriceController.text,
      "oldPrice": oldPriceController.text,
      "discount": discountController.text,
      "expiryDate": endDateController.value.text,
      "validDate": startDateController.value.text,
      "totalOrder": 0,
      "itemsIncluded": itemIncludedModel,
      "customizationForDrinks": drinksModel,
      "customizationForFlavours": flavoursModel
    };

    await databaseReference.child('Deals').push().set(data).whenComplete(() async {
      Get.back();
      Get.back();
      Utils().showToast('dataUpdated'.tr);
    }).onError((error, stackTrace) {
      Get.back();
      Utils().showToast(error.toString());
    });
  }

  updateImage() async {
    String pImages = '';
    if (productImage.value.path != '') {
      String? filePathImage;
      if (Platform.isAndroid) {
        filePathImage = widget.dealsModel!.image
            .toString()
            .replaceAll(new RegExp(r'https://firebasestorage.googleapis.com/v0/b/foodizm-flutter-bac9e.appspot.com/o/DealImages%2F'), '')
            .split('?')[0];
      } else if (Platform.isIOS) {
        filePathImage = widget.dealsModel!.image
            .toString()
            .replaceAll(new RegExp(r'https://firebasestorage.googleapis.com:443/v0/b/foodizm-flutter-bac9e.appspot.com/o/DealImages%2F'), '')
            .split('?')[0];
      }

      FirebaseStorage.instance.ref().child('DealImages/').child(filePathImage!).delete().then((_) async {
        Reference ref =
            storage.ref().child("DealImages/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(productImage.value.path));
        UploadTask uploadTask = ref.putFile(File(productImage.value.path));
        final TaskSnapshot url = (await uploadTask);
        pImages = await url.ref.getDownloadURL();
        updateDeal(pImages);
      });
    } else {
      pImages = widget.dealsModel!.image!;
      updateDeal(pImages);
    }
  }

  updateDeal(String productImage) async {
    List<String>? itemIncludedModel = [];
    List<String>? flavoursModel = [];
    List<String>? drinksModel = [];

    if (itemIncludedValue.value == 1) {
      for (int i = 0; i < Common.selectedItemIncludedList.length; i++) {
        itemIncludedModel.add(Common.selectedItemIncludedList[i]);
      }
    } else {
      itemIncludedModel.add('default');
    }

    if (flavourValue.value == 1) {
      for (int i = 0; i < Common.selectedFlavourList.length; i++) {
        flavoursModel.add(Common.selectedFlavourList[i]);
      }
    } else {
      flavoursModel.add('default');
    }

    if (drinksValue.value == 1) {
      for (int i = 0; i < Common.selectedDrinksList.length; i++) {
        drinksModel.add(Common.selectedDrinksList[i]);
      }
    } else {
      drinksModel.add('default');
    }

    Map<String, dynamic> data = {
      "title": titleController.text,
      "details": descriptionController.text,
      "image": productImage,
      "type": 'deal',
      "no_of_serving": noOfServingController.text,
      "timeCreated": widget.dealsModel!.timeCreated!,
      "newPrice": newPriceController.text,
      "oldPrice": oldPriceController.text,
      "discount": discountController.text,
      "expiryDate": endDateController.value.text,
      "validDate": startDateController.value.text,
      "itemsIncluded": itemIncludedModel,
      "customizationForDrinks": drinksModel,
      "customizationForFlavours": flavoursModel
    };

    Query query = databaseReference.child('Deals').orderByChild('timeCreated').equalTo(widget.dealsModel!.timeCreated!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Deals').child(value.toString()).update(data);
          Get.back();
          Get.back();
          Utils().showToast('dataUpdated'.tr);
        });
      }
    });
  }

  void showDeleteDialog() {
    Get.defaultDialog(
      title: "confirmation".tr,
      content: Text(
        "deleteProduct".tr,
        textAlign: TextAlign.center,
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("no".tr),
        style: ElevatedButton.styleFrom(primary: AppColors.primaryColor),
      ),
      confirm: ElevatedButton(
        onPressed: () async {
          Get.back();
          utils.showLoadingDialog();
          Query query = databaseReference.child('Deals').orderByChild('timeCreated').equalTo(widget.dealsModel!.timeCreated!);
          await query.once().then((DataSnapshot snapshot) {
            if (snapshot.exists) {
              Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
              mapOfMaps.keys.forEach((value) async {
                await databaseReference.child('Deals').child(value.toString()).remove();
                Get.back();
                Get.back();
                Utils().showToast('productDeleted'.tr);
              });
            }
          });
        },
        child: Text("yes".tr),
        style: ElevatedButton.styleFrom(primary: Colors.red),
      ),
    );
  }
}
