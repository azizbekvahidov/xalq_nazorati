import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class SupportInfo extends StatefulWidget {
  @override
  _SupportInfoState createState() => _SupportInfoState();
}

class _SupportInfoState extends State<SupportInfo> {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xff12B79B), Color(0xff00AC8A)],
  ).createShader(Rect.fromLTRB(0.0, 0.0, 0.0, 0.0));
  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
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
            "call_message".tr().toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff313B6C),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: globals.font,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 20),
          child: Text(
            "1055",
            style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w700,
                fontFamily: globals.font,
                foreground: Paint()..shader = linearGradient),
          ),
        ),
        InkWell(
          onTap: () {
            launchUrl("tel://1055");
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 98),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: 50,
              child: Text(
                "call".tr().toString(),
                style: TextStyle(
                    fontSize: 18,
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
