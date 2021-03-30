import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:system_settings/system_settings.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xalq_nazorati/widget/custom_modal.dart';
import 'package:xalq_nazorati/widget/permission_modal.dart';
import '../widget/default_button.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CustomDottedCircleContainer extends StatefulWidget {
  final double boxSize;
  File image;
  final String img;

  CustomDottedCircleContainer(this.boxSize, this.image, this.img);
  @override
  _CustomDottedCircleContainerState createState() =>
      _CustomDottedCircleContainerState();
}

class _CustomDottedCircleContainerState
    extends State<CustomDottedCircleContainer> {
  bool accessDenied;

  // Future<PermissionStatus> _getPermission(perm) async {
  //   PermissionStatus permission =
  //       await PermissionHandler().checkPermissionStatus(perm);
  //   if (permission != PermissionStatus.granted) {
  //     Map<PermissionGroup, PermissionStatus> permisionStatus =
  //         await PermissionHandler().requestPermissions([perm]);
  //     return permisionStatus[perm] ?? PermissionStatus.unknown;
  //   } else {
  //     print(permission);
  //     return permission;
  //   }
  // }

  void _getLocation() async {
    var status = await Permission.location.status;
    print(status);
    if (status.isUndetermined || status.isDenied) {
      Permission.location.request();
      // We didn't ask for permission yet.
    }
    globals.userLocation = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  customDialog(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;

    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return CustomModal(
                widthAxis: 0.85,
                heightAxis: 0.32,
              );
            },
          );
        });
  }

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'warning'.tr().toString(),
      customDialog: CustomModal(
        widthAxis: 0.85,
        heightAxis: 0.32,
      ),
      appNameColor: Colors.black,
      cancelText: 'cancel'.tr().toString(),
      enableLocationMessage: 'permission_text'.tr().toString(),
      goToSettingsText: 'go_settings'.tr().toString(),
    );
    var result = await permissionValidator.camera();
    if (result) {
      File _img = await ImagePicker.pickImage(source: ImageSource.camera);
      if (_img != null && globals.validateFile(_img)) {
        // widget.image = _img;
        print("take shot");
        // await _getLocation();
        final dir = await path_provider.getTemporaryDirectory();

        final targetPath =
            dir.absolute.path + "/${Time()}${_img.path.split("/").last}";
        _img = await testCompressAndGetFile(_img, targetPath);
        setState(() {
          globals.images.addAll({widget.img: _img});
        });
      }
    }
  }

  pickerCam() async {
    _permissionRequest();
    // var status = await Permission.camera.status;
    // if (status.isUndetermined || status.isDenied) {
    //
    //   // We didn't ask for permission yet.
    // } else if (status.isPermanentlyDenied) {
    //   customDialog(context);
    // } else {
    //   File _img = await ImagePicker.pickImage(source: ImageSource.camera);
    //   if (_img != null && globals.validateFile(_img)) {
    //     // widget.image = _img;
    //     print("take shot");
    //     // await _getLocation();
    //     final dir = await path_provider.getTemporaryDirectory();

    //     final targetPath =
    //         dir.absolute.path + "/${Time()}${_img.path.split("/").last}";
    //     _img = await testCompressAndGetFile(_img, targetPath);
    //     setState(() {
    //       globals.images.addAll({widget.img: _img});
    //     });
    //   }
    // }
    // ignore: deprecated_member_use
  }

  pickGallery() async {
    if (Platform.isAndroid) {
      var status = await Permission.accessMediaLocation.status;
      if (status.isUndetermined || status.isDenied) {
        Permission.accessMediaLocation.request();
        status = await Permission.accessMediaLocation.status;
        if (!status.isDenied && !status.isPermanentlyDenied) {
          File _img = await ImagePicker.pickImage(source: ImageSource.gallery);

          if (_img != null && globals.validateFile(_img)) {
            // widget.image = _img;

            final dir = await path_provider.getTemporaryDirectory();

            final targetPath =
                dir.absolute.path + "/${Time()}${_img.path.split("/").last}";
            _img = await testCompressAndGetFile(_img, targetPath);
            globals.images.addAll({widget.img: _img});
            setState(() {});
          }
        }
      } else if (status.isPermanentlyDenied) {
        customDialog(context);
      } else {
        File _img = await ImagePicker.pickImage(source: ImageSource.gallery);

        if (_img != null && globals.validateFile(_img)) {
          // widget.image = _img;

          final dir = await path_provider.getTemporaryDirectory();

          final targetPath =
              dir.absolute.path + "/${Time()}${_img.path.split("/").last}";
          _img = await testCompressAndGetFile(_img, targetPath);
          globals.images.addAll({widget.img: _img});
          setState(() {});
        }
      }
    } else if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isUndetermined) {
        Permission.accessMediaLocation.request();
        status = await Permission.accessMediaLocation.status;
        if (!status.isDenied && !status.isPermanentlyDenied) {
          File _img = await ImagePicker.pickImage(source: ImageSource.gallery);

          if (_img != null && globals.validateFile(_img)) {
            // widget.image = _img;

            final dir = await path_provider.getTemporaryDirectory();

            final targetPath =
                dir.absolute.path + "/${Time()}${_img.path.split("/").last}";
            _img = await testCompressAndGetFile(_img, targetPath);
            globals.images.addAll({widget.img: _img});
            setState(() {});
          }
        }
      } else if (status.isPermanentlyDenied || status.isDenied) {
        customDialog(context);
      } else {
        File _img = await ImagePicker.pickImage(source: ImageSource.gallery);

        if (_img != null && globals.validateFile(_img)) {
          // widget.image = _img;

          final dir = await path_provider.getTemporaryDirectory();

          final targetPath =
              dir.absolute.path + "/${Time()}${_img.path.split("/").last}";
          _img = await testCompressAndGetFile(_img, targetPath);
          globals.images.addAll({widget.img: _img});
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    File _file = globals.images[widget.img];
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                height: 320,
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "choose_photo".tr().toString(),
                      style: Theme.of(context).textTheme.display2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: InkWell(
                        onTap: () {
                          pickerCam();
                          Navigator.of(context).pop();
                          print("click to camera");
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/img/camera.svg"),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "from_camera".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff66676C),
                                  fontFamily: globals.font,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: InkWell(
                        onTap: () {
                          pickGallery();
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/img/image.svg"),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "from_gallery".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff66676C),
                                  fontFamily: globals.font,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    DefaultButton("cancel".tr().toString(), () {
                      Navigator.of(context).pop();
                    }, Theme.of(context).primaryColor),
                  ],
                ),
              );
            });
      },
      child: _file == null
          ? DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(widget.boxSize / 2),
              dashPattern: [12, 7],
              color: Color.fromRGBO(103, 105, 108, 0.5),
              strokeWidth: 2,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.boxSize / 2)),
                child: Container(
                  padding: EdgeInsets.all(22),
                  child: SvgPicture.asset(
                    "assets/img/plus_icon.svg",
                    color: Color.fromRGBO(49, 59, 108, 0.5),
                  ),
                  width: widget.boxSize,
                  height: widget.boxSize,
                ),
              ),
            )
          : ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.boxSize / 2)),
              child: Container(
                child: FittedBox(
                  child: Image.file(_file),
                  fit: BoxFit.cover,
                ),
                width: widget.boxSize,
                height: widget.boxSize,
              ),
            ),
    );
  }
}
