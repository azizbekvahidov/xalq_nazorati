import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as http;
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/http_get.dart';
import '../../screen/register/pass_recognize_screen.dart';
import '../../widget/input/default_input.dart';
import '../../widget/default_button.dart';
import '../../widget/text/main_text.dart';

class RegisterVerifyScreen extends StatefulWidget {
  static const routeName = "/register-phone-verify";
  final phoneView;
  final phone;
  RegisterVerifyScreen({this.phoneView, this.phone});

  @override
  _RegisterVerifyScreenState createState() => _RegisterVerifyScreenState();
}

class _RegisterVerifyScreenState extends State<RegisterVerifyScreen> {
  bool _value = false;
  String _showTime = "03:00";
  Timer _timer;
  final codeController = TextEditingController();
  int _start = 180;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
            // _showTime = "$_start";
            int min = (_start / 60).toInt();
            int sec = _start - (min * 60);
            String secs = "$sec";
            if (sec < 10) secs = "0$sec";
            _showTime = "0$min:$secs";
          }
        },
      ),
    );
  }

  void resendCode() async {
    if (_start == 0) {
      var url = 'https://new.xalqnazorati.uz/ru/api/users/retry-signup-code';
      var r1 = await Requests.post(url, verify: false, persistCookies: true);
      r1.raiseForStatus();

      _start = 180;
      startTimer();
      // print(responseBody["detail"]);
    }
  }

  bool isSend = false;
  void verify() async {
    String code = codeController.text;

    if (!isSend && code != "") {
      String url = '${globals.api_link}/users/signup-confirm';
      Map map = {"code": int.parse(code)};
      // String url = '${globals.api_link}/users/get-phone';
      var r1 = await Requests.post(url,
          body: map, verify: false, persistCookies: true);
      r1.raiseForStatus();

      // dynamic json = r1.json();
      // print(json["detail"]);
      if (r1.statusCode == 200) isSend = true;
      if (isSend) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            settings: const RouteSettings(name: PassRecognizeScreen.routeName),
            builder: (context) => PassRecognizeScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
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
                                "Проверка",
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
                                "Введите 5 значный код, который мы отправили на номер ${widget.phoneView}",
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
                          MainText("Код подтверждения"),
                          DefaultInput("Введите код", codeController),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                width: mediaQuery.size.width * 0.85,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _showTime,
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
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
                                  "Продолжить",
                                  () {
                                    verify();
                                  },
                                  Theme.of(context).primaryColor,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Не получили код?",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        fontSize: dWith < 400 ? 13 : 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        resendCode();
                                      },
                                      child: Text(
                                        "Отправить снова",
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
