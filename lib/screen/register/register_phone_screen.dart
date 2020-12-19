import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/screen/rule_page.dart';
import '../login_screen.dart';
import './register_verify_screen.dart';
import '../../widget/default_button.dart';
import '../../widget/text/main_text.dart';
import '../../widget/input/phone_input.dart';

class RegisterPhoneScreen extends StatefulWidget {
  static const routeName = "/register-phone";

  @override
  _RegisterPhoneScreenState createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  final phoneController = TextEditingController();
  bool _value = false;
  String phoneWiew = "";
  bool isRegister = false;
  void getCode() async {
    // String phone = "+998${phoneController.text}";
    // phone = phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    // if (phoneController.text == "") phone = "";

    // if (!isRegister && phone != "") {
    //   try {
    //     String url =
    //         '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/signup-code';
    //     Map map = {"phone": phone};

    //     var status = await Permission.sms.status;
    //     if (status.isUndetermined || status.isDenied) {
    //       Permission.sms.request().then((value) async {
    //         status = await Permission.sms.status;
    //         if (status.isGranted) {
    //           var r1 = await Requests.post(url, body: map);
    //           // Navigator.of(context).push(MaterialPageRoute(
    //           //     settings:
    //           //         const RouteSettings(name: RegisterVerifyScreen.routeName),
    //           //     builder: (context) => RegisterVerifyScreen(
    //           //           phoneView: phoneWiew,
    //           //           phone: phone,
    //           //         )));
    //           if (r1.statusCode == 200) {
    //             dynamic json = r1.json();
    //             r1.raiseForStatus();
    //             print(r1.content());
    //             isRegister = true;
    //             phoneWiew = json["phone_view"];
    //             if (isRegister && _value) {
    //               setState(() {
    //                 phoneController.text = "";
    //                 _value = !_value;
    //               });
    //               isRegister = false;
    //               Navigator.of(context).push(MaterialPageRoute(
    //                   settings: const RouteSettings(
    //                       name: RegisterVerifyScreen.routeName),
    //                   builder: (context) => RegisterVerifyScreen(
    //                         phoneView: phoneWiew,
    //                         phone: phone,
    //                       )));
    //             }
    //           } else {
    //             dynamic json = r1.json();
    //             print(json['detail']);
    //             Fluttertoast.showToast(
    //                 msg: json['detail'],
    //                 toastLength: Toast.LENGTH_SHORT,
    //                 gravity: ToastGravity.BOTTOM,
    //                 timeInSecForIosWeb: 2,
    //                 backgroundColor: Colors.grey,
    //                 textColor: Colors.white,
    //                 fontSize: 15.0);
    //             print(json);
    //           }
    //         }
    //       });
    //       // We didn't ask for permission yet.
    //     } else {
    //       var r1 = await Requests.post(url, body: map);

    //       if (r1.statusCode == 200) {
    //         dynamic json = r1.json();
    //         r1.raiseForStatus();
    //         print(r1.content());
    //         isRegister = true;
    //         phoneWiew = json["phone_view"];
    //         if (isRegister && _value) {
    //           setState(() {
    //             phoneController.text = "";
    //             _value = !_value;
    //           });
    //           isRegister = false;
    Navigator.of(context).push(MaterialPageRoute(
        settings: const RouteSettings(name: RegisterVerifyScreen.routeName),
        builder: (context) => RegisterVerifyScreen()));
    //         }
    //       } else {
    //         dynamic json = r1.json();
    //         print(json['detail']);
    //         Fluttertoast.showToast(
    //             msg: json['detail'],
    //             toastLength: Toast.LENGTH_SHORT,
    //             gravity: ToastGravity.BOTTOM,
    //             timeInSecForIosWeb: 2,
    //             backgroundColor: Colors.grey,
    //             textColor: Colors.white,
    //             fontSize: 15.0);
    //         print(json);
    //       }
    //     }
    //   } catch (e) {
    //     print(e);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dWidth = mediaQuery.size.width;
    final dHeight = mediaQuery.size.height;
    final PreferredSizeWidget appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white),
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff12B79B),
            Color(0xff00AC8A),
          ],
        ),
      ),
      child: Scaffold(
        appBar: appBar,
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: dHeight * 0.3 -
                      appBar.preferredSize.height, //mediaQuery.size.height,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 30, left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "sign_ups".tr().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: dWidth * globals.fontSize26,
                                    fontFamily: globals.font,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                Text(
                                  "reg_title_desc".tr().toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: dWidth * globals.fontSize18,
                                    fontFamily: globals.font,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: mediaQuery.size.height - dHeight * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText("tel_number_title".tr().toString()),
                            PhoneInput(phoneController),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _value = !_value;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2,
                                            style: BorderStyle.solid,
                                            color:
                                                Theme.of(context).primaryColor),
                                        shape: BoxShape.circle,
                                        color: _value
                                            ? Theme.of(context).primaryColor
                                            : Colors.transparent),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: _value
                                          ? Icon(
                                              Icons.check,
                                              size: 15.0,
                                              color: Colors.white,
                                            )
                                          : Icon(
                                              Icons.check_box_outline_blank,
                                              size: 15.0,
                                              color: Colors.transparent,
                                            ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  width: mediaQuery.size.width * 0.75,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "reg_offer_aggreement_start"
                                              .tr()
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize:
                                                dWidth * globals.fontSize12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(
                                                  context, RulePage.routeName);
                                            },
                                          text: "offer".tr().toString(),
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontFamily: globals.font,
                                            fontSize:
                                                dWidth * globals.fontSize12,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "reg_offer_aggreement_end"
                                              .tr()
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize:
                                                dWidth * globals.fontSize12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Positioned(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  !_value
                                      ? DefaultButton(
                                          "sign_up".tr().toString(),
                                          () {},
                                          Color(0xffB2B7D0),
                                        )
                                      : DefaultButton(
                                          "sign_up".tr().toString(),
                                          () {
                                            getCode();
                                            // Navigator.of(context).pushNamed(
                                            //     RegisterVerifyScreen.routeName);
                                          },
                                          Theme.of(context).primaryColor,
                                        ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "accaunt_question2".tr().toString(),
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWidth * globals.fontSize14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  LoginScreen.routeName,
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        child: Text(
                                          "log_in".tr().toString(),
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize:
                                                dWidth * globals.fontSize14,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
