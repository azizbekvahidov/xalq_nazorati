import 'package:flutter/material.dart';

class SuccessBox extends StatelessWidget {
  final Widget children;
  const SuccessBox({this.children, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 188, 156, 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xff1ABC9C),
        ),
      ),
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      width: dWidth,
      child: children,
    );
  }
}
