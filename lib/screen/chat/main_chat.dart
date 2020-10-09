import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';

class MainChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Служба поддержки",
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF5F6F9),
        ),
        child: Center(
          child: Text("Chat"),
        ),
      ),
    );
  }
}
