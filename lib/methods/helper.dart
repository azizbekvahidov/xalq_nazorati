import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../globals.dart' as globals;
import '';

class Helper {
  void getToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Color(0xffFBE8E8),
        textColor: Color(0xffE31C1C),
        fontSize: 12.0);
  }
}
