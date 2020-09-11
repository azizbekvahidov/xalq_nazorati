import 'package:flutter/material.dart';

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
          fontFamily: "Gilroy",
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
