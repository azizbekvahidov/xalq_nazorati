import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class ProblemSolveDesc extends StatelessWidget {
  final String leftTxt;
  final String rightTxt;
  ProblemSolveDesc(this.leftTxt, this.rightTxt);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                "$leftTxt:",
                style: TextStyle(
                  fontFamily: globals.font,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                rightTxt,
                style: TextStyle(
                  fontFamily: globals.font,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
        )
      ],
    );
  }
}
