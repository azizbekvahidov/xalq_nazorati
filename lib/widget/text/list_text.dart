import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class ListText extends StatelessWidget {
  final String txt1;
  final String txt2;
  ListText(this.txt1, this.txt2);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: txt1,
              style: TextStyle(
                color: Colors.black,
                fontFamily: globals.font,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
            TextSpan(
              text: txt2,
              style: TextStyle(
                color: Colors.black,
                fontFamily: globals.font,
                fontWeight: FontWeight.w300,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
