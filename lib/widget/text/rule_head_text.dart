import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class RuleHeadText extends StatelessWidget {
  final String txt;
  RuleHeadText(this.txt);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Text(
        txt,
        style: TextStyle(
          color: Colors.black,
          fontFamily: globals.font,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
