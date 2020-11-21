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
import 'package:xalq_nazorati/screen/register/forgot_pass.dart';
import 'package:xalq_nazorati/screen/rule_page.dart';
import '../login_screen.dart';
import 'register_verify_screen.dart';
import '../../widget/default_button.dart';
import '../../widget/text/main_text.dart';
import '../../widget/input/phone_input.dart';

class ForgotPassPhone extends StatefulWidget {
  static const routeName = "/forgot-pass-phone";

  @override
  _ForgotPassPhoneState createState() => _ForgotPassPhoneState();
}

class _ForgotPassPhoneState extends State<ForgotPassPhone> {
  final phoneController = TextEditingController();
  bool _value = false;
  String phoneWiew = "";
  bool isRegister = false;
  void getCode() async {
    String phone = "+998${phoneController.text}";
    phone = phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    if (phoneController.text == "") phone = "";

    if (phone != "") {
      try {
        String url =
            '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/recover-code';
        Map map = {"phone": phone};

        var status = await Permission.sms.status;
        if (status.isUndetermined || status.isDenied) {
          Permission.sms.request().then((value) async {
            status = await Permission.sms.status;
            if (status.isGranted) {
              var r1 = await Requests.post(url,
                  body: map, verify: false, persistCookies: true);

              if (r1.statusCode == 200) {
                dynamic json = r1.json();
                r1.raiseForStatus();
                print(r1.content());
                isRegister = true;
                phoneWiew = json["phone_view"];
                if (isRegister) {
                  setState(() {
                    phoneController.text = "";
                  });
                  isRegister = false;
                  Navigator.of(context).push(MaterialPageRoute(
                      settings: const RouteSettings(name: ForgotPass.routeName),
                      builder: (context) => ForgotPass(
                            phoneView: phoneWiew,
                            phone: phone,
                          )));
                }
              } else {
                dynamic json = r1.json();
                print(json['detail']);
                Fluttertoast.showToast(
                    msg: json['detail'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 15.0);
                print(json);
              }
            }
          });
          // We didn't ask for permission yet.
        } else {
          var r1 = await Requests.post(url,
              body: map, verify: false, persistCookies: true);

          if (r1.statusCode == 200) {
            dynamic json = r1.json();
            r1.raiseForStatus();
            print(r1.content());
            isRegister = true;
            phoneWiew = json["phone_view"];
            if (isRegister) {
              setState(() {
                phoneController.text = "";
              });
              isRegister = false;
              Navigator.of(context).push(MaterialPageRoute(
                  settings: const RouteSettings(name: ForgotPass.routeName),
                  builder: (context) => ForgotPass(
                        phoneView: phoneWiew,
                        phone: phone,
                      )));
            }
          } else {
            dynamic json = r1.json();
            print(json['detail']);
            Fluttertoast.showToast(
                msg: json['detail'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 15.0);
            print(json);
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
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
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                                "reset_txt".tr().toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  fontFamily: globals.font,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                              ),
                              Text(
                                "reset_desc".tr().toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
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
                                DefaultButton(
                                  "send".tr().toString(),
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
                                      "",
                                      style: TextStyle(
                                        fontFamily: globals.font,
                                        fontSize: dWith < 400 ? 13 : 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () => null,
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWith < 400 ? 13 : 14,
                                          color: Theme.of(context).primaryColor,
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
    );
  }
}
