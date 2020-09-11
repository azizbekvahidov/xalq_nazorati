import 'package:flutter/material.dart';

class LittleParagText extends StatelessWidget {
  final String txt;
  LittleParagText(this.txt);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: Text(
        txt,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Gilroy",
          fontWeight: FontWeight.w300,
          fontSize: 10,
        ),
      ),
    );
  }
}
