import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/widget/problems/image_carousel.dart';
import 'package:xalq_nazorati/widget/problems/pdf_widget.dart';

class ResContent extends StatelessWidget {
  final String titleCol;
  final String dateCol;
  final String contentCol;
  final String positionCol;
  final List files;

  const ResContent(
      {this.titleCol,
      this.dateCol,
      this.positionCol,
      this.contentCol,
      this.files,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(files[0]);
    var dWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 19, top: 5, right: 19, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleCol,
                      style: TextStyle(
                        fontFamily: globals.font,
                        fontSize: dWidth * globals.fontSize14,
                        fontWeight: FontWeight.w600,
                        fontFeatures: [
                          FontFeature.enable("pnum"),
                          FontFeature.enable("lnum")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      width: dWidth * 0.8 - 40,
                      child: Text(
                        positionCol,
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: dWidth * globals.fontSize12,
                          fontWeight: FontWeight.w400,
                          fontFeatures: [
                            FontFeature.enable("pnum"),
                            FontFeature.enable("lnum")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "execute_date".tr().toString(),
                      style: TextStyle(
                        fontFamily: globals.font,
                        fontSize: dWidth * globals.fontSize12,
                        fontWeight: FontWeight.w400,
                        fontFeatures: [
                          FontFeature.enable("pnum"),
                          FontFeature.enable("lnum")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Text(
                      dateCol,
                      style: TextStyle(
                        fontFamily: globals.font,
                        fontSize: dWidth * globals.fontSize14,
                        fontWeight: FontWeight.w600,
                        fontFeatures: [
                          FontFeature.enable("pnum"),
                          FontFeature.enable("lnum")
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "description".tr().toString(),
                  style: TextStyle(
                    fontFamily: globals.font,
                    fontSize: dWidth * globals.fontSize12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    contentCol,
                    style: TextStyle(
                      fontFamily: globals.font,
                      fontSize: dWidth * globals.fontSize14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          files == null || (files[0].length == 0 && files[1].length == 0)
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "picked_files".tr().toString(),
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: dWidth * globals.fontSize12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      files[1].length != 0
                          ? Container(
                              height: 80,
                              child: GridView.builder(
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 4,
                                ),
                                itemCount: files[1].length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return PdfWidget(files[1][index], "");
                                },
                              ),
                            )
                          : Container(),
                      files[0].length != 0
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: ImageCarousel(
                                "",
                                files[0],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
