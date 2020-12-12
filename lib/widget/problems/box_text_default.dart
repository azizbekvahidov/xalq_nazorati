import 'dart:ui';

import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter/material.dart';

class BoxTextDefault extends StatelessWidget {
  final String txt;

  BoxTextDefault(this.txt);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(178, 183, 208, 0.25),
        border: Border.all(color: Color(0xffB2B7D0)),
        borderRadius: BorderRadius.circular(2.5),
      ),
      child: Text(
        txt,
        style: TextStyle(
          color: Colors.black,
          fontFamily: globals.font,
          fontSize: 10,
          fontFeatures: [
            FontFeature.enable("pnum"),
            FontFeature.enable("lnum")
          ],
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
