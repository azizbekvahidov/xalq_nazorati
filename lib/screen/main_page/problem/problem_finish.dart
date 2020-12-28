import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/main_page/main_page.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_content_screen.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/default_button.dart';

class ProblemFinish extends StatefulWidget {
  final int id;
  ProblemFinish({this.id});
  @override
  _ProblemFinishState createState() => _ProblemFinishState();
}

class _ProblemFinishState extends State<ProblemFinish> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globals.routeProblemId = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var dWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(
              left: mediaQuery.size.width * 0.06,
              right: mediaQuery.size.width * 0.06,
              top: mediaQuery.size.height * 0.15),
          height: mediaQuery.size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "good".tr().toString(),
                      style: TextStyle(
                        color: Color(0xff313B6C),
                        fontFamily: globals.font,
                        fontWeight: FontWeight.bold,
                        fontSize: dWidth * globals.fontSize24,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                    ),
                    Text(
                      "finish_message".tr().toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff66676C),
                          fontSize: dWidth * globals.fontSize14,
                          fontWeight: FontWeight.w400,
                          fontFamily: globals.font),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: mediaQuery.size.height * 0.05),
                    ),
                    SvgPicture.asset(
                      "assets/img/finish.svg",
                      width: mediaQuery.size.width * 0.35,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "finish_and".tr().toString(),
                    style: TextStyle(
                        color: Color(0xff66676C),
                        fontSize: dWidth * globals.fontSize14,
                        fontWeight: FontWeight.w400,
                        fontFamily: globals.font),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      "finish_and_txt".tr().toString(),
                      style: TextStyle(
                          color: Color(0xff66676C),
                          fontSize: dWidth * globals.fontSize14,
                          fontWeight: FontWeight.w400,
                          fontFamily: globals.font),
                    ),
                  ),
                ],
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: mediaQuery.size.height * 0.05),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child:
                              /*!_value
                                ? DefaultButton(
                                    "Продолжить",
                                    () {},
                                    Color(0xffB2B7D0),
                                  )
                                : */
                              DefaultButton("understand".tr().toString(), () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return HomePage();
                            }), (Route<dynamic> route) => false);
                          }, Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
