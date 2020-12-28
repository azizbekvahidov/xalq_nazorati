import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class ResContent extends StatelessWidget {
  final String titleCol;
  final String dateCol;
  final String contentCol;
  final String positionCol;

  const ResContent(
      {this.titleCol, this.dateCol, this.positionCol, this.contentCol, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 19, top: 5, right: 19, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
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
                  "Описание",
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
        ],
      ),
    );
  }
}
