import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class CardList extends StatelessWidget {
  final String title;
  final String name;

  CardList(this.title, this.name);
  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: TextStyle(
                fontSize: dWidth * globals.fontSize12,
                fontFamily: globals.font,
                color: Color(0xff66676C),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              name,
              style: TextStyle(
                fontFeatures: [
                  FontFeature.enable("pnum"),
                  FontFeature.enable("lnum")
                ],
                fontFamily: globals.font,
                fontSize: dWidth * globals.fontSize18,
                fontWeight: FontWeight.w500,
                color: Color(0xff000000),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
