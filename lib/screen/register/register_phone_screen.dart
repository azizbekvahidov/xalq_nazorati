import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widget/checkbox_custom.dart';
import '../login_screen.dart';
import './register_verify_screen.dart';
import '../../widget/default_button.dart';
import '../../widget/main_text.dart';
import '../../widget/phone_input.dart';

class RegisterPhoneScreen extends StatefulWidget {
  static const routeName = "/register-phone";

  @override
  _RegisterPhoneScreenState createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar()
        : AppBar(
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
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                height:
                    270 - appBar.preferredSize.height, //mediaQuery.size.height,
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
                                "Регистрация",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  fontFamily: 'Gilroy',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                              ),
                              Text(
                                "Зарегистрируйтесь чтобы получить онлайн консультацию",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  fontFamily: 'Gilroy',
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
                height: mediaQuery.size.height - 270,
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
                          MainText("Номер мобильного телефона"),
                          PhoneInput(),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CheckboxCustom(_value),
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                width: mediaQuery.size.width * 0.75,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Я ознакомился и согласен с условиями ",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: new Text(
                                        "публичной оферты",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontFamily: "Gilroy",
                                          fontSize: 13,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                DefaultButton(
                                  "Зарегистрироваться",
                                  () {
                                    Navigator.of(context).pushNamed(
                                        RegisterVerifyScreen.routeName);
                                  },
                                  Theme.of(context).primaryColor,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "У вас уже есть аккаунт?",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                LoginScreen.routeName);
                                      },
                                      child: Text(
                                        "Войти",
                                        style: TextStyle(
                                          fontFamily: "Gilroy",
                                          fontSize: 14,
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
