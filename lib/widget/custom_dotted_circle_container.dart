import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widget/default_button.dart';

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

  pickerCam() async {
    // ignore: deprecated_member_use
    File _img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (_img != null && validate(_img)) {
      // widget.image = _img;
      globals.images.addAll({widget.img: _img});
      await _getLocation();
      setState(() {});
    }
  }

  pickGallery() async {
    File _img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_img != null && validate(_img)) {
      // widget.image = _img;
      globals.images.addAll({widget.img: _img});
      setState(() {});
    }
  }

  bool validate(File img) {
    if (img.lengthSync() > 10485760) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    File _file = globals.images[widget.img];
    return InkWell(
      onTap: () {
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
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: InkWell(
                        onTap: () {
                          pickGallery();
                          Navigator.of(context).pop();
                          print("click to gallery");
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
