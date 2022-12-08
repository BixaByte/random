import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodizm_admin_app/database_model/driver_model.dart';
import 'package:foodizm_admin_app/utils/utils.dart';
import 'package:foodizm_admin_app/colors.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DriverWidget extends StatefulWidget {
  final DriverModel? driverModel;
  final Function? function;

  const DriverWidget({Key? key, this.driverModel, this.function}) : super(key: key);

  @override
  _DriverWidgetState createState() => _DriverWidgetState();
}

class _DriverWidgetState extends State<DriverWidget> {
  Utils utils = new Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 15, right: 15),
      child: Card(
        elevation: 2,
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(minHeight: 50.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
              ),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    decoration: new BoxDecoration(
                      color: AppColors.whiteColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    height: 60,
                    width: 60,
                    child: widget.driverModel!.profileImage == null
                        ? SvgPicture.asset('assets/images/man.svg')
                        : widget.driverModel!.profileImage != 'default'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.driverModel!.profileImage!,
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                    height: 30,
                                    width: 30,
                                    child: Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                  ),
                                  errorWidget: (context, url, error) => SvgPicture.asset('assets/images/man.svg'),
                                ),
                              )
                            : SvgPicture.asset('assets/images/man.svg'),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          utils.poppinsMediumText(
                            widget.driverModel!.fullName != null && widget.driverModel!.fullName != 'default' ? widget.driverModel!.fullName : 'N/A',
                            16.0,
                            AppColors.blackColor,
                            TextAlign.start,
                          ),
                          utils.poppinsMediumText(
                            widget.driverModel!.phoneNumber != null && widget.driverModel!.phoneNumber != 'default'
                                ? widget.driverModel!.phoneNumber
                                : 'N/A',
                            16.0,
                            AppColors.blackColor,
                            TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: SlideAction(
                onSubmit: () {
                  widget.function!(widget.driverModel!);
                },
                height: 45,
                submittedIcon: Icon(Icons.check_rounded, color: AppColors.whiteColor),
                sliderRotate: false,
                alignment: Alignment.centerRight,
                innerColor: AppColors.whiteColor,
                outerColor: AppColors.primaryColor,
                child: utils.poppinsMediumText('Slide To Assign Order', 14.0, AppColors.whiteColor, TextAlign.start),
                sliderButtonIcon: Icon(Icons.double_arrow_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
