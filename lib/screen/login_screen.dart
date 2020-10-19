import 'dart:convert';
import 'dart:io';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
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
    var url = '${globals.api_link}/users/signin';
    Map map = {"phone": phone, "password": pass};
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
      print(response.json());
    }

    if (isLogin) Navigator.of(context).pushReplacementNamed(HomePage.routeName);
  }

  addStringToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                height: 300, //mediaQuery.size.height,
                width: double.infinity,
                child: Center(
                  child: SvgPicture.asset("assets/img/FrameW.svg"),
                ),
              ),
              Container(
                width: double.infinity,
                height: mediaQuery.size.height - 300,
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
                          MainText("tel_number_hint".tr().toString()),
                          PhoneInput(phoneController),
                          MainText("Пароль"),
                          PassInput("Введите пароль", passController),
                        ],
                      ),
                      Positioned(
                        child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DefaultButton("Войти", () {
                                  getLogin();
                                }, Theme.of(context).primaryColor),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "У вас еще нет аккаунта?",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        fontSize: dWith < 400 ? 13 : 14,
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
                                        "Зарегистрируйтесь",
                                        style: TextStyle(
                                          fontFamily: "Gilroy",
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
