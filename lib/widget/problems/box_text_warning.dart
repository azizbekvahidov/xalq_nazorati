import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class BoxTextWarning extends StatelessWidget {
  final String txt;
  final String status;

  BoxTextWarning(this.txt, this.status);
  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    Color _bgcolor = Color(0xffFEF0DB);
    Color _borderColor = Color.fromRGBO(255, 165, 21, 0.5);
    Color _txtColor = Color(0xffFFA515);
    if (status == 'warning') {
      _bgcolor = Color(0xffFEF0DB);
      _borderColor = Color.fromRGBO(255, 165, 21, 0.5);
      _txtColor = Color(0xffFFA515);
    } else if (status == 'danger') {
      _bgcolor = Color(0xffF5D7D7);
      _borderColor = Color(0xffFF5555);
      _txtColor = Color(0xffFF5555);
    } else if (status == 'success') {
      _bgcolor = Color(0xffCCEDE7);
      _borderColor = Color(0xff1ABC9C);
      _txtColor = Color(0xff1ABC9C);
    } else if (status == 'delayed') {
      _bgcolor = Color(0xffCCEDE7);
      _borderColor = Color(0xff1ABC9C);
      _txtColor = Color(0xff1ABC9C);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      decoration: BoxDecoration(
        color: _bgcolor,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(2.9),
      ),
      child: Text(
        txt,
        style: TextStyle(
          color: _txtColor,
          fontFamily: globals.font,
          fontWeight: FontWeight.w500,
          fontSize: dWidth * globals.fontSize10,
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
