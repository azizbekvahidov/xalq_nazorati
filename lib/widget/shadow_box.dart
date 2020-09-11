import 'package:flutter/material.dart';

class ShadowBox extends StatelessWidget {
  final Widget child;
  ShadowBox({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
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
