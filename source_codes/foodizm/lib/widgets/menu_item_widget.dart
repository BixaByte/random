import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodizm/colors.dart';
import 'package:foodizm/common/common.dart';
import 'package:foodizm/models/product_model.dart';
import 'package:foodizm/screens/product_detail_screen.dart';
import 'package:foodizm/utils/utils.dart';
import 'package:get/get.dart';

class MenuItemWidget extends StatefulWidget {
  final ProductModel? productModel;

  const MenuItemWidget({Key? key, this.productModel}) : super(key: key);

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  Utils utils = new Utils();
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addView();
        Get.to(() => ProductDetailScreen(type: 'Items', productModel: widget.productModel, dealsModel: null));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Container(
              decoration: new BoxDecoration(color: AppColors.whiteColor, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryColor)),
              height: 80,
              width: 80,
              child: Padding(
                padding: EdgeInsets.all(7),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: widget.productModel!.image != null && widget.productModel!.image != 'default'
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.productModel!.image!,
                            progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                              height: 50,
                              width: 50,
                              child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            ),
                            errorWidget: (context, url, error) => Image.asset("assets/images/placeholder_image.png", fit: BoxFit.cover),
                          )
                        : Image.asset("assets/images/placeholder_image.png", fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: utils.poppinsSemiBoldText(widget.productModel!.title!, 12.0, AppColors.blackColor, TextAlign.center),
            ),
            utils.poppinsSemiBoldText(Common.currency + ' ' + widget.productModel!.price!, 14.0, AppColors.primaryColor, TextAlign.center),
          ],
        ),
      ),
    );
  }

  addView() async {
    Query query = databaseReference.child('Items').orderByChild("title").equalTo(widget.productModel!.title!);
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
        mapOfMaps.keys.forEach((value) async {
          Query query1 = databaseReference.child('Items').child(value).child('views').orderByChild('userID').equalTo(utils.getUserId());
          await query1.once().then((DataSnapshot snapshot1) {
            if (!snapshot1.exists) {
              databaseReference.child('Items').child(value).child('views').push().set({
                'userID': utils.getUserId(),
                'lastView': DateTime.now().millisecondsSinceEpoch.toString(),
              });
              increaseViewCount(value);
            }
          });
        });
      }
    });
  }

  increaseViewCount(String value) async {
    Query query = databaseReference.child('Items').child(value).child('viewsCount');
    await query.once().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        databaseReference.child('Items').child(value).update({'viewsCount': snapshot.value + 1});
      } else {
        databaseReference.child('Items').child(value).update({'viewsCount': 1});
      }
    });
  }
}
