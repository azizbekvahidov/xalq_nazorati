import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class SupportFeedback extends StatelessWidget {
  var descController = TextEditingController();
  final codeController = TextEditingController();
  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: 220,
          height: 241,
          child: Image.asset("assets/img/support.png"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35, right: 22, left: 22),
          child: Text(
            "send_to_bot_message".tr().toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff313B6C),
              fontSize: width * globals.fontSize18,
              fontWeight: FontWeight.bold,
              fontFamily: globals.font,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            launchUrl("https://t.me/xalqnazorati_bot");
          },
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: width * 0.15, vertical: 30),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 18),
              height: 50,
              child: Text(
                "send_notify".tr().toString(),
                style: TextStyle(
                    fontSize: width * globals.fontSize18,
                    fontWeight: FontWeight.w400,
                    fontFamily: globals.font,
                    color: Colors.white),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff12B79B),
                    Color(0xff00AC8A),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
