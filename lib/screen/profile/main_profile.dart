import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/login_screen.dart';
import 'package:xalq_nazorati/screen/profile/problem/problem_screen.dart';
import 'package:xalq_nazorati/widget/get_login_dialog.dart';
import '../../widget/select_lang.dart';
import '../../screen/profile/info_page.dart';
import '../../screen/profile/profile_page.dart';
import '../../widget/custom_card_list.dart';
import '../../widget/default_button.dart';
import '../../widget/icon_card_list.dart';
import '../../widget/shadow_box.dart';

class MainProfile extends StatefulWidget {
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  String _lang;
  String _country;
  Future<void> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    String stringValue = prefs.getString('lang');
    String stringC = prefs.getString('country');
    setState(() {
      _lang = stringValue;
      _country = stringC;
    });
  }

  customDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: GetLoginDialog(),
            ),
          );
        });
  }

  Future<void> addStringToSF(String lang, String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', lang);
    prefs.setString('country', _country);
    globals.lang = lang;
    setState(() {
      _lang = lang;
      _country = country;
    });
  }

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
  }

  Future quitProfile() async {
    var url =
        '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/logout';
    Map map = {
      "fcm_token": globals.deviceToken,
    };
    Map<String, String> headers = {"Authorization": "token ${globals.token}"};
    var response = await Requests.post(
      url,
      headers: headers,
      body: map,
    );
    // request.methodPost(map, url);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userToken', null);
      globals.userData = null;
      globals.token = null;
    } else {
      var responseBody = response.json();
      print(responseBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(4, 6), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            title: Container(
              width: double.infinity,
              height: 70,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    globals.token != null
                        ? "${globals.capitalize(globals.userData['last_name'])} ${globals.capitalize(globals.userData['first_name'])}"
                        : "",
                    style: Theme.of(context).textTheme.display2.copyWith(
                          fontSize: mediaQuery.size.width * globals.fontSize20,
                        ),
                  ),
                  Text(
                    globals.token != null ? "${globals.userData['phone']}" : "",
                    style: TextStyle(
                        fontFeatures: [
                          FontFeature.enable("pnum"),
                          FontFeature.enable("lnum")
                        ],
                        color: Color(0xff66676C),
                        fontSize: mediaQuery.size.width * globals.fontSize12,
                        fontFamily: globals.font),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   padding: EdgeInsets.only(
              //     left: 20,
              //     top: 20,
              //   ),
              //   child: Text(
              //     "profile_messages".tr().toString(),
              //     style: TextStyle(
              //       color: Color(0xff66676C),
              //       fontFamily: globals.font,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),

              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Text(
                  "common".tr().toString(),
                  style: TextStyle(
                    color: Color(0xff66676C),
                    fontFamily: globals.font,
                    fontSize: mediaQuery.size.width * globals.fontSize16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ShadowBox(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: (mediaQuery.size.width -
                                              mediaQuery.padding.left -
                                              mediaQuery.padding.right) *
                                          0.82,
                                      child: Container(
                                          child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(right: 13),
                                            child: SvgPicture.asset(
                                                "assets/img/profile_icon.svg"),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "profile".tr().toString(),
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                color: Color(0xff050505),
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    mediaQuery.size.width *
                                                        globals.fontSize18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))),
                                  Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (globals.token != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ProfilePage();
                                    },
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                              } else {
                                customDialog(context);
                              }
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: (mediaQuery.size.width -
                                              mediaQuery.padding.left -
                                              mediaQuery.padding.right) *
                                          0.82,
                                      child: Container(
                                          child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(right: 13),
                                            child: SvgPicture.asset(
                                                "assets/img/lang_icon.svg"),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  "change_lang".tr().toString(),
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                color: Color(0xff050505),
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    mediaQuery.size.width *
                                                        globals.fontSize18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))),
                                  Container(
                                    child: Icon(
                                      Icons.more_horiz,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => SelectLang(
                                      lang: _lang, callBack: addStringToSF));
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: (mediaQuery.size.width -
                                              mediaQuery.padding.left -
                                              mediaQuery.padding.right) *
                                          0.82,
                                      child: Container(
                                          child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(right: 13),
                                            child: SvgPicture.asset(
                                                "assets/img/info_icon.svg"),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "about_app".tr().toString(),
                                              style: TextStyle(
                                                fontFamily: globals.font,
                                                color: Color(0xff050505),
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    mediaQuery.size.width *
                                                        globals.fontSize18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))),
                                  Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return InfoPage();
                                  },
                                ),
                              );
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    (globals.token != null)
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: (mediaQuery.size.width -
                                                      mediaQuery.padding.left -
                                                      mediaQuery
                                                          .padding.right) *
                                                  0.84,
                                              child: Container(
                                                  child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        right: 13),
                                                    child: SvgPicture.asset(
                                                        "assets/img/quit_icon.svg"),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: "log_out"
                                                          .tr()
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            globals.font,
                                                        color:
                                                            Color(0xff050505),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: mediaQuery
                                                                .size.width *
                                                            globals.fontSize18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      quitProfile().then((value) {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pushNamedAndRemoveUntil(
                                                HomePage.routeName,
                                                (Route<dynamic> route) =>
                                                    false);
                                      });
                                    }),
                                Divider(),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              // ShadowBox(
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "У тебя есть идея?",
              //           style: TextStyle(
              //             color: Color(0xff313B6C),
              //             fontFamily: globals.font,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(top: 15),
              //           child: Text(
              //             "Перейти на сайт, в разделе «Идеи» Вы можете отправить свои предложения по улучшению городской инфраструктуры, а также оценить идеи, поданные другими пользователями.",
              //             style: TextStyle(
              //               color: Color(0xff050505),
              //               fontFamily: globals.font,
              //               fontSize: 12,
              //               fontWeight: FontWeight.normal,
              //             ),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.only(top: 30),
              //           child: DefaultButton(
              //             "Перейти на сайт",
              //             () {},
              //             Theme.of(context).primaryColor,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.all(7),
              )
            ],
          ),
        ),
      ),
    );
  }
}
