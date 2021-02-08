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
    var width = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomIconAppBar(
        title: "bugs_problem".tr().toString(),
        icon: "assets/img/support.svg",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: dHeight - 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    Container(
                      child: Image.asset(
                        "assets/img/support.png",
                        width: width <= 360 ? width * 0.4 : width * 0.5,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 35, right: 22, left: 22),
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
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.12, vertical: 30),
                child: InkWell(
                  onTap: () {
                    launchUrl("https://t.me/xalqnazorati_bot");
                  },
                  child: Container(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      height: 50,
                      child: Text(
                        "send_notify".tr().toString(),
                        style: TextStyle(
                            fontSize: width * globals.fontSize16,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
