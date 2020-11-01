import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/widget/app_bar/custom_icon_appbar.dart';

class MainSupport extends StatefulWidget {
  @override
  _MainSupportState createState() => _MainSupportState();
}

class _MainSupportState extends State<MainSupport> {
  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomIconAppBar(
        title: "bugs_problem".tr().toString(),
        icon: "assets/img/support.svg",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
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
                  fontSize: 18,
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
                padding: EdgeInsets.symmetric(horizontal: 72, vertical: 30),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  height: 50,
                  child: Text(
                    "send_notify".tr().toString(),
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
        ),
      ),
    );
  }
}
