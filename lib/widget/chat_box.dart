import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

class ChatBox extends StatelessWidget {
  final String val;
  const ChatBox({this.val, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Color(0xffB2B7D0)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        val,
        style: TextStyle(
          fontFamily: globals.font,
          fontSize: dWidth * globals.fontSize8,
          fontWeight: FontWeight.w300,
          color: Color(0xff242121),
        ),
      ),
    );
  }
}
