import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class ProblemSolveDesc extends StatelessWidget {
  final String leftTxt;
  final String rightTxt;
  ProblemSolveDesc(this.leftTxt, this.rightTxt);
  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
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
                  fontSize: dWidth * globals.fontSize14,
                  fontFeatures: [
                    FontFeature.enable("pnum"),
                    FontFeature.enable("lnum")
                  ],
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
                  fontSize: dWidth * globals.fontSize14,
                  fontFeatures: [
                    FontFeature.enable("pnum"),
                    FontFeature.enable("lnum")
                  ],
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
