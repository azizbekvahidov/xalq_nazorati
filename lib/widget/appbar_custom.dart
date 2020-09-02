import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AppbarCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoNavigationBar()
        : AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.white),
          );
  }
}
