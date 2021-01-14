import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  final Widget child;
  Color bgColor;
  ShadowBox({this.child, this.bgColor = Colors.white});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffD5D8E5), width: 0.5),
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(4, 6), // changes position of shadow
          ),
        ],
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: child,
    );
  }
}
