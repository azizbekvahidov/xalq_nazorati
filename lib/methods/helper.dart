import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';
import 'package:toast/toast.dart';
import '../globals.dart' as globals;
import '';

class Helper {
  void getToast(msg, BuildContext context) {
    Toast.show(
      msg,
      context,
      backgroundColor: Color.fromRGBO(251, 232, 232, 1),
      textColor: Color(0xffE31C1C),
      duration: Toast.LENGTH_LONG,
      gravity: Toast.TOP,
      backgroundRadius: 10,
      border: Border.all(
        color: Colors.red,
        width: 0.5,
      ),
    );
    // Fluttertoast.showToast(
    //     msg: msg,
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.TOP,
    //     timeInSecForIosWeb: 2,
    //     backgroundColor: Color.fromRGBO(251, 232, 232, 0.3),
    //     textColor: Color(0xffE31C1C),
    //     fontSize: 12.0);
  }
}
