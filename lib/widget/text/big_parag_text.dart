import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class BigParagText extends StatelessWidget {
  final String txt;
  BigParagText(this.txt);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, left: 10),
      child: Text(
        txt,
        style: TextStyle(
          color: Colors.black,
          fontFamily: globals.font,
          fontWeight: FontWeight.normal,
          fontSize: 11,
        ),
      ),
    );
  }
}
