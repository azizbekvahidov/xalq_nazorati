import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xalq_nazorati/methods/check_connection.dart';
import 'package:xalq_nazorati/screen/register/android_camera.dart';
import 'package:xalq_nazorati/screen/register/camera_page.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/widget/shadow_box.dart';

class PasRecognizeNotify extends StatefulWidget {
  PasRecognizeNotify({Key key}) : super(key: key);

  @override
  _PasRecognizeNotifyState createState() => _PasRecognizeNotifyState();
}

class _PasRecognizeNotifyState extends State<PasRecognizeNotify> {
  @override
  Widget build(BuildContext context) {
    var meduaQuery = MediaQuery.of(context).size;
    var dWidth = meduaQuery.width;
    return Stack(
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "how_scan_pas".tr().toString(),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ShadowBox(
              child: Container(
                padding: EdgeInsets.only(
                    left: 28,
                    right: 28,
                    top: meduaQuery.height * 0.05,
                    bottom: meduaQuery.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1) ${"pas_notify_text_1".tr().toString()}",
                      style: TextStyle(
                        color: Color(0xff313B6C),
                        fontFamily: globals.font,
                        fontSize: dWidth * globals.fontSize12,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [
                          FontFeature.enable("pnum"),
                          FontFeature.enable("lnum")
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "2) ${"pas_notify_text_2".tr().toString()}",
                      style: TextStyle(
                        color: Color(0xff313B6C),
                        fontFamily: globals.font,
                        fontSize: dWidth * globals.fontSize12,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [
                          FontFeature.enable("pnum"),
                          FontFeature.enable("lnum")
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "3) ${"pas_notify_text_3".tr().toString()}",
                      style: TextStyle(
                        color: Color(0xff313B6C),
                        fontFamily: globals.font,
                        fontSize: dWidth * globals.fontSize12,
                        fontWeight: FontWeight.w500,
                        fontFeatures: [
                          FontFeature.enable("pnum"),
                          FontFeature.enable("lnum")
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "4) ",
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize: dWidth * globals.fontSize12,
                              color: Color(0xff313B6C),
                              fontWeight: FontWeight.w500,
                              fontFeatures: [
                                FontFeature.enable("pnum"),
                                FontFeature.enable("lnum")
                              ],
                            ),
                          ),
                          TextSpan(
                            text: "${"pas_notify_text_4-1".tr().toString()}",
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize: dWidth * globals.fontSize12,
                              color: Color(0xffDE1B1B),
                              fontWeight: FontWeight.w700,
                              fontFeatures: [
                                FontFeature.enable("pnum"),
                                FontFeature.enable("lnum")
                              ],
                            ),
                          ),
                          TextSpan(
                            text: "pas_notify_text_4-2".tr().toString(),
                            style: TextStyle(
                              fontFamily: globals.font,
                              fontSize: dWidth * globals.fontSize12,
                              color: Color(0xff313B6C),
                              fontWeight: FontWeight.w500,
                              fontFeatures: [
                                FontFeature.enable("pnum"),
                                FontFeature.enable("lnum")
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 27),
                      child: Image.asset(
                        "assets/img/iPhone11.png",
                        height: meduaQuery.height * 0.30,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 40)),
                    InkWell(
                      onTap: () async {
                        final res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Platform.isAndroid
                                    ? AndroidCameraPage()
                                    : CameraScreen()));
                        if (res != null) {
                          Navigator.pop(context, res);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: meduaQuery.width,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(29),
                          color: Theme.of(context).primaryColor,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 29),
                        child: Text(
                          "scan_begin".tr().toString(),
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: globals.font,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        CheckConnection(),
      ],
    );
  }
}
