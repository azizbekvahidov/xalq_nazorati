import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widget/app_bar/custom_icon_appbar.dart';

class MainChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomIconAppBar(
        title: "Служба поддержки",
        icon: "assets/img/chat.svg",
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
