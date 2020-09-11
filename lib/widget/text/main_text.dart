import 'package:flutter/material.dart';

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
