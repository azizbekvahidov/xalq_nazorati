import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

class DefaultSelect extends StatefulWidget {
  final Widget child;
  DefaultSelect({this.child, Key key}) : super(key: key);

  @override
  _DefaultSelectState createState() => _DefaultSelectState();
}

class _DefaultSelectState extends State<DefaultSelect> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: Color(0xffF5F6F9),
        borderRadius: BorderRadius.circular(22.5),
        border: Border.all(
          color: Color.fromRGBO(178, 183, 208, 0.5),
          style: BorderStyle.solid,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: (mediaQuery.size.width -
                    mediaQuery.padding.left -
                    mediaQuery.padding.right) *
                (mediaQuery.size.width <= 360 ? 0.74 : 0.78),
            child:
                // Container(
                //   height: 40,
                //   margin: EdgeInsets.symmetric(vertical: 10),
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   decoration: BoxDecoration(
                //       border: Border.all(color: Color(0xff707070)),
                //       borderRadius: BorderRadius.circular(6)),
                //   width: widget.dWidth,
                //   child:
                widget.child,
            // );
          ),
        ],
      ),
    );
  }
}
