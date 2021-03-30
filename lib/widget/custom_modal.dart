import 'package:flutter/material.dart';
import 'package:xalq_nazorati/widget/permission_modal.dart';

class CustomModal extends StatefulWidget {
  double widthAxis;
  double heightAxis;
  CustomModal({this.widthAxis, this.heightAxis, Key key}) : super(key: key);

  @override
  _CustomModalState createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          width: dWidth * widget.widthAxis,
          height: dHeight * widget.heightAxis,
          padding: EdgeInsets.symmetric(
            vertical: dHeight * 0.03,
            horizontal: dWidth * 0.01,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: PermissionModal(),
          ),
        ),
      ),
    );
  }
}
