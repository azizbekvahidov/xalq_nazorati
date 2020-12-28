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
      _bgcolor = Color(0xffF99500);
      _borderColor = Color.fromRGBO(255, 165, 21, 0.5);
      _txtColor = Color(0xffFFFFFF);
    } else if (status == 'info') {
      _bgcolor = Color(0xff0082F9);
      _borderColor = Color(0xff0082F9);
      _txtColor = Color(0xffFFFFFF);
    } else if (status == 'danger') {
      _bgcolor = Color(0xffFF2F2F);
      _borderColor = Color(0xffFF2F2F);
      _txtColor = Color(0xffFFFFFF);
    } else if (status == 'success') {
      _bgcolor = Color(0xff1ABC9C);
      _borderColor = Color(0xff1ABC9C);
      _txtColor = Color(0xffFFFFFF);
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
