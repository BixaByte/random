import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodizm_admin_app/database_model/categories_model.dart';
import 'package:foodizm_admin_app/database_model/product_model.dart';
import 'package:foodizm_admin_app/database_model/variation_model.dart';
import 'package:foodizm_admin_app/models/selected_variation_model.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'package:foodizm_admin_app/screens/add_flavour_screen.dart';
import 'package:foodizm_admin_app/screens/add_ingredients_screen.dart';
import 'package:foodizm_admin_app/screens/add_variations_screen.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductScreen extends StatefulWidget {
  final String? origin;
  final ProductModel? productModel;

  const AddProductScreen({Key? key, this.origin, this.productModel}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  Utils utils = new Utils();
  RxString categoryId = ''.obs;
  var titleController = new TextEditingController();
  var priceController = new TextEditingController();
  var noOfServingController = new TextEditingController();
  var descriptionController = new TextEditingController();
  var formKey = GlobalKey<FormState>();
  RxInt flavourValue = 1.obs;
  RxInt variationsValue = 1.obs;
  RxInt ingredientsValue = 1.obs;
  Rx<File> productImage = File('').obs;
  FirebaseStorage storage = FirebaseStorage.instance;
  var databaseReference = FirebaseDatabase.instance.reference();
  List<VariationModel>? variationModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Common.selectedFlavourList.clear();
    Common.selectedVariationsList.clear();
    Common.selectedIngredientsList.clear();

    if (widget.origin == 'edit') {
      titleController.text = widget.productModel!.title!;
      priceController.text = widget.productModel!.price!;
      noOfServingController.text = widget.productModel!.noOfServing!;
      descriptionController.text = widget.productModel!.details!;
      categoryId.value = widget.productModel!.categoryId!;

      if (widget.productModel!.customizationForFlavours![0] == 'default') {
        flavourValue.value = 0;
      } else {
        flavourValue.value = 1;
        for (int i = 0; i < widget.productModel!.customizationForFlavours!.length; i++) {
          Common.selectedFlavourList.add(widget.productModel!.customizationForFlavours![i]);
        }
      }

      if (widget.productModel!.ingredients![0] == 'default') {
        ingredientsValue.value = 0;
      } else {
        ingredientsValue.value = 1;
        for (int i = 0; i < widget.productModel!.ingredients!.length; i++) {
          Common.selectedIngredientsList.add(widget.productModel!.ingredients![i]);
        }
      }

      if (widget.productModel!.customizationForVariations![0]!['name'] == 'default') {
        variationsValue.value = 0;
      } else {
        variationsValue.value = 1;
        for (int i = 0; i < widget.productModel!.customizationForVariations!.length; i++) {
          Map<String, dynamic> mapOfMaps = Map.from(widget.productModel!.customizationForVariations![i]!);
          variationModel!.add(VariationModel.fromJson(Map.from(mapOfMaps)));
          Common.selectedVariationsList.add(SelectedVariationsModel(variationModel![i].name, variationModel![i].price));
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
        title: utils.poppinsMediumText(widget.origin == 'add' ? 'addNewItem'.tr : 'editItem'.tr, 18.0, AppColors.blackColor, TextAlign.center),
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
                            ? widget.origin == 'edit' && widget.productModel!.image != 'default'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: widget.productModel!.image!,
                                      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                        height: 50,
                                        width: 50,
                                        child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                      ),
                                      errorWidget: (context, url, error) => Image.asset('assets/images/placeholder_image.png', fit: BoxFit.cover),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/upload.png", height: 40, width: 40, color: AppColors.lightGreyColor),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: utils.poppinsMediumText('uploadItemImage'.tr, 14.0, AppColors.lightGreyColor, TextAlign.center),
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
              // Category
              Obx(() => Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: Get.width,
                    decoration: utils.boxDecoration(AppColors.whiteColor, AppColors.primaryColor),
                    child: DropdownButton(
                      value: categoryId.value == '' ? null : categoryId.value,
                      isExpanded: true,
                      underline: Container(),
                      hint: utils.poppinsRegularText('chooseCategory'.tr, 14.0, AppColors.primaryColor, TextAlign.start),
                      icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? data) {
                        categoryId.value = data!;
                      },
                      items: Common.categoriesList.map((CategoriesModel? category) {
                        return DropdownMenuItem<String>(
                          value: category!.timeCreated!,
                          child: Text(category.title!),
                        );
                      }).toList(),
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
                        decoration: utils.inputDecorationWithLabel('enterItemName'.tr, 'itemName'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enterProductName'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    // Price
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: utils.inputDecorationWithLabel('enterItemPrice'.tr, 'itemPrice'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterItemPrice'.tr;
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
                        decoration: utils.inputDecorationWithLabel('enterNoOfItemServing'.tr, 'itemServing'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterNoOfItemServing'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    // Description
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        controller: descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 10,
                        decoration: utils.inputDecorationWithLabel('enterItemDetails'.tr, 'itemDetails'.tr, AppColors.whiteColor, AppColors.primaryColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterItemDetails'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Flavour
              Obx(() => makeRadioButtonWidgets('itemHasFlavour'.tr, 'addItemFlavour'.tr, flavourValue.value, flavourChange)),
              // Selected Flavour
              Obx(() => Column(
                    children: [
                      for (int i = 0; i < Common.selectedFlavourList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            initialValue: Common.selectedFlavourList[i],
                            readOnly: true,
                            decoration: utils.inputDecorationWithLabel('enterItemFlavour'.tr, 'itemFlavour'.tr, AppColors.whiteColor, AppColors.primaryColor),
                          ),
                        ),
                    ],
                  )),
              // Variations
              Obx(() => makeRadioButtonWidgets('itemHasVariations'.tr, 'addItemVariations'.tr, variationsValue.value, variationsChange)),
              // Selected Variations
              Obx(() => Column(
                    children: [
                      for (int i = 0; i < Common.selectedVariationsList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: TextFormField(
                                    initialValue: Common.selectedVariationsList[i].title,
                                    readOnly: true,
                                    decoration: utils.inputDecorationWithLabel('enterVariationsTitle'.tr, 'variationsTitle'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: TextFormField(
                                    initialValue: Common.selectedVariationsList[i].price,
                                    readOnly: true,
                                    decoration: utils.inputDecorationWithLabel('enterVariationsPrice'.tr, 'variationsPrice'.tr, AppColors.whiteColor, AppColors.primaryColor),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  )),
              // Ingredients
              Obx(() => makeRadioButtonWidgets('itemHasIngredients'.tr, 'addItemIngredients'.tr, ingredientsValue.value, ingredientsChange)),
              // Selected Ingredients
              Obx(() => Column(
                    children: [
                      for (int i = 0; i < Common.selectedIngredientsList.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            initialValue: Common.selectedIngredientsList[i],
                            readOnly: true,
                            decoration:
                                utils.inputDecorationWithLabel('enterItemIngredients'.tr, 'itemIngredients'.tr, AppColors.whiteColor, AppColors.primaryColor),
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
                        if (categoryId.value != '') {
                          checkValidationForFlavour();
                        } else {
                          utils.showToast('selectCategory'.tr);
                        }
                      } else {
                        utils.showToast('selectItemImage'.tr);
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
                  child: Center(child: utils.poppinsMediumText('saveItem'.tr, 16.0, AppColors.whiteColor, TextAlign.center)),
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
                    if (subTitle == 'addItemFlavour'.tr)
                      Get.to(() => AddFlavoursScreen());
                    else if (subTitle == 'addItemVariations'.tr)
                      Get.to(() => AddVariationsScreen());
                    else if (subTitle == 'addItemIngredients'.tr) Get.to(() => AddIngredientsScreen());
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

  void variationsChange(value) {
    variationsValue.value = value;
    Common.selectedVariationsList.clear();
  }

  void ingredientsChange(value) {
    ingredientsValue.value = value;
    Common.selectedIngredientsList.clear();
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
        checkValidationForVariations();
      } else {
        utils.showToast('pleaseAddItemFlavour'.tr);
      }
    } else {
      checkValidationForVariations();
    }
  }

  checkValidationForVariations() {
    if (variationsValue.value == 1) {
      if (Common.selectedVariationsList.length > 0) {
        checkValidationForIngredients();
      } else {
        utils.showToast('pleaseAddItemVariations'.tr);
      }
    } else {
      checkValidationForIngredients();
    }
  }

  checkValidationForIngredients() {
    if (ingredientsValue.value == 1) {
      if (Common.selectedIngredientsList.length > 0) {
        utils.showLoadingDialog();
        if (widget.origin == 'add') {
          saveProduct();
        } else {
          updateImage();
        }
      } else {
        utils.showToast('pleaseAddItemIngredients'.tr);
      }
    } else {
      utils.showLoadingDialog();
      if (widget.origin == 'add') {
        saveProduct();
      } else {
        updateImage();
      }
    }
  }

  saveProduct() async {
    List<Map<String, dynamic>?>? variationModel = [];
    List<String>? flavoursModel = [];
    List<String>? ingredientsModel = [];

    if (variationsValue.value == 1) {
      for (int i = 0; i < Common.selectedVariationsList.length; i++) {
        variationModel.add({'name': Common.selectedVariationsList[i].title, 'price': Common.selectedVariationsList[i].price});
      }
    } else {
      variationModel.add({'name': 'default', 'price': 'default'});
    }

    if (flavourValue.value == 1) {
      for (int i = 0; i < Common.selectedFlavourList.length; i++) {
        flavoursModel.add(Common.selectedFlavourList[i]);
      }
    } else {
      flavoursModel.add('default');
    }

    if (ingredientsValue.value == 1) {
      for (int i = 0; i < Common.selectedIngredientsList.length; i++) {
        ingredientsModel.add(Common.selectedIngredientsList[i]);
      }
    } else {
      ingredientsModel.add('default');
    }

    Reference ref =
        storage.ref().child("ProductsImages/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(productImage.value.path));
    UploadTask uploadTask = ref.putFile(File(productImage.value.path));
    final TaskSnapshot downloadUrlIcon = (await uploadTask);
    String url = await downloadUrlIcon.ref.getDownloadURL();

    Map<String, dynamic> data = {
      "categoryId": categoryId.value,
      "title": titleController.text,
      "details": descriptionController.text,
      "image": url,
      "type": 'item',
      "no_of_serving": noOfServingController.text,
      "timeCreated": DateTime.now().millisecondsSinceEpoch.toString(),
      "price": priceController.text,
      "totalOrder": 0,
      "ingredients": ingredientsModel,
      "customizationForVariations": variationModel,
      "customizationForFlavours": flavoursModel
    };

    await databaseReference.child('Items').push().set(data).whenComplete(() async {
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
        filePathImage = widget.productModel!.image
            .toString()
            .replaceAll(new RegExp(r'https://firebasestorage.googleapis.com/v0/b/foodizm-flutter-bac9e.appspot.com/o/ProductsImages%2F'), '')
            .split('?')[0];
      } else if (Platform.isIOS) {
        filePathImage = widget.productModel!.image
            .toString()
            .replaceAll(new RegExp(r'https://firebasestorage.googleapis.com:443/v0/b/foodizm-flutter-bac9e.appspot.com/o/ProductsImages%2F'), '')
            .split('?')[0];
      }

      FirebaseStorage.instance.ref().child('ProductsImages/').child(filePathImage!).delete().then((_) async {
        Reference ref =
            storage.ref().child("ProductsImages/").child(DateTime.now().millisecondsSinceEpoch.toString() + p.extension(productImage.value.path));
        UploadTask uploadTask = ref.putFile(File(productImage.value.path));
        final TaskSnapshot url = (await uploadTask);
        pImages = await url.ref.getDownloadURL();
        updateProduct(pImages);
      });
    } else {
      pImages = widget.productModel!.image!;
      updateProduct(pImages);
    }
  }

  updateProduct(String productImage) async {
    List<Map<String, dynamic>?>? variationModel = [];
    List<String>? flavoursModel = [];
    List<String>? ingredientsModel = [];

    if (variationsValue.value == 1) {
      for (int i = 0; i < Common.selectedVariationsList.length; i++) {
        variationModel.add({'name': Common.selectedVariationsList[i].title, 'price': Common.selectedVariationsList[i].price});
      }
    } else {
      variationModel.add({'name': 'default', 'price': 'default'});
    }

    if (flavourValue.value == 1) {
      for (int i = 0; i < Common.selectedFlavourList.length; i++) {
        flavoursModel.add(Common.selectedFlavourList[i]);
      }
    } else {
      flavoursModel.add('default');
    }

    if (ingredientsValue.value == 1) {
      for (int i = 0; i < Common.selectedIngredientsList.length; i++) {
        ingredientsModel.add(Common.selectedIngredientsList[i]);
      }
    } else {
      ingredientsModel.add('default');
    }

    Map<String, dynamic> data = {
      "categoryId": categoryId.value,
      "title": titleController.text,
      "details": descriptionController.text,
      "image": productImage,
      "type": 'item',
      "no_of_serving": noOfServingController.text,
      "timeCreated": widget.productModel!.timeCreated!,
      "price": priceController.text,
      "ingredients": ingredientsModel,
      "customizationForVariations": variationModel,
      "customizationForFlavours": flavoursModel
    };

    Query query = databaseReference.child('Items').orderByChild('timeCreated').equalTo(widget.productModel!.timeCreated!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          await databaseReference.child('Items').child(value.toString()).update(data);
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
          Query query = databaseReference.child('Items').orderByChild('timeCreated').equalTo(widget.productModel!.timeCreated!);
          await query.once().then((DataSnapshot snapshot) {
            if (snapshot.exists) {
              Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
              mapOfMaps.keys.forEach((value) async {
                await databaseReference.child('Items').child(value.toString()).remove();
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
