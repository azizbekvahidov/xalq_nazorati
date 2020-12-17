import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class MainText extends StatelessWidget {
  final String txt;
  MainText(this.txt);
  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        txt,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(fontSize: dWidth * globals.fontSize16),
      ),
    );
  }
}
