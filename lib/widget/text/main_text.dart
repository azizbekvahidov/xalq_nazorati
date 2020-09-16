import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MainText extends StatelessWidget {
  final String txt;
  MainText(this.txt);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        txt,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
}
