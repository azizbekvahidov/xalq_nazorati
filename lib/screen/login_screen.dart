import 'package:fluttertoast/fluttertoast.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'package:xalq_nazorati/screen/register/forgot_pass_phone.dart';
import 'register/register_phone_screen.dart';
import '../widget/input/pass_input.dart';
import '../widget/default_button.dart';
import '../widget/text/main_text.dart';
import '../widget/input/phone_input.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-page";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passController = TextEditingController();
  bool isLogin = false;
  void getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', null);
    String phone = "+998${phoneController.text}";
    phone = phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String pass = passController.text;
    var url =
        '${globals.site_link}/${(globals.lang).tr().toString()}/api/users/signin';
    Map map = {
      "phone": phone,
      "password": pass,
      "fcm_token": globals.deviceToken,
      "device_type": globals.device,
      "lang": globals.lang.tr().toString()
    };
    var response = await Requests.post(
      url,
      body: map,
    );
    // request.methodPost(map, url);
    if (response.statusCode == 200) {
      // Map<String,dynamic> reply = response.json();

      Map<String, dynamic> responseBody = response.json();
      addStringToSF(responseBody["token"]);
      globals.token = responseBody["token"];
      isLogin = true;
    } else {
      Map<String, dynamic> responseBody = response.json();
      Fluttertoast.showToast(
          msg: responseBody['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 15.0);
    }

    if (isLogin)
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          HomePage.routeName, (Route<dynamic> route) => false);
  }

  addStringToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
    final dHeight = mediaQuery.size.height;
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
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                  height: dHeight * 0.35, //mediaQuery.size.height,
                  width: double.infinity,
                  child: Center(
                    child: SvgPicture.asset("assets/img/FrameW.svg"),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: dHeight * 0.65,
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
                            MainText("pass_title".tr().toString()),
                            PassInput("pass_hint".tr().toString(),
                                passController, null),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ForgotPassPhone.routeName);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  "forgot_pass".tr().toString(),
                                  style: TextStyle(
                                      fontFamily: globals.font,
                                      fontSize: 16,
                                      color: Color(0xff858589)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  DefaultButton("log_in".tr().toString(), () {
                                    getLogin();
                                  }, Theme.of(context).primaryColor),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "accaunt_question".tr().toString(),
                                        style: TextStyle(
                                          fontFamily: globals.font,
                                          fontSize: dWith * globals.fontSize14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              RegisterPhoneScreen.routeName);
                                        },
                                        child: Text(
                                          "sign_ups".tr().toString(),
                                          style: TextStyle(
                                            fontFamily: globals.font,
                                            fontSize:
                                                dWith * globals.fontSize14,
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
