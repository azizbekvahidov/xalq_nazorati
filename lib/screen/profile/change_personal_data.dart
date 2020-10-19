import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/models/user.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/widget/input/default_input.dart';
import 'package:xalq_nazorati/widget/input/phone_icon_input.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ChangePersonalData extends StatefulWidget {
  @override
  _ChangePersonalDataState createState() => _ChangePersonalDataState();
}

class _ChangePersonalDataState extends State<ChangePersonalData> {
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  String _showTime = "03:00";
  Timer _timer;
  int _start = 180;

  final codeController = TextEditingController();

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

  Future changeProfile() async {
    try {
      String address = addressController.text;
      String email = emailController.text;
      String code = "${codeController.text}";
      if (code != "") {
        changePhone(code);
      }
      if (address != "" || email != "") {
        var url = '${globals.api_link}/users/profile';

        Map<String, String> map = {};
        if (address != '') map.addAll({"address_str": address});
        if (email != '') map.addAll({"email": email});
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}",
        };
        // var req = await http.put(Uri.parse(url), headers: headers, body: map);
        var r1 =
            await Requests.put(url, body: map, headers: headers, verify: false);
        print(r1.json());
        if (r1.statusCode == 200) {
          r1.raiseForStatus();
          Map<String, dynamic> reply = await r1.json();

          globals.userData = reply;
          print(reply["address_str"]);
          Navigator.of(context).pop();
        } else {
          print(json);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future sendMessage() async {
    if (_start == 0) {
      _start = 180;
      sendMessage();
    } else if (_start == 180) {
      try {
        String phone = "+998${phoneController.text}";
        phone = phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        var url = '${globals.api_link}/users/change-phone';

        Map map = {
          "phone": phone,
        };
        Map<String, String> headers = {
          "Authorization": "token ${globals.token}",
        };
        var r1 = await Requests.post(url,
            body: map, headers: headers, verify: false);
        print(r1.content());

        if (r1.statusCode == 200) {
          r1.raiseForStatus();
          startTimer();
          // Navigator.of(context).pop();
        } else {
          print(json);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future changePhone(String code) async {
    try {
      var url = '${globals.api_link}/users/code-validation';

      Map map = {
        "code": code,
      };
      Map<String, String> headers = {
        "Authorization": "token ${globals.token}",
      };
      var r1 =
          await Requests.post(url, body: map, headers: headers, verify: false);
      print(r1.content());

      if (r1.statusCode == 200) {
        r1.raiseForStatus();
        _timer.cancel();
        Navigator.of(context).pop();
      } else {
        print(json);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '__ ___ __ __', filter: {"_": RegExp(r'[0-9]')});
    final mediaQuery = MediaQuery.of(context);
    final appbar = CustomAppBar(
      title: "Изменить пароль",
    );
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appbar,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: mediaQuery.size.height - mediaQuery.size.height * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShadowBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText("Адрес фактического проживания"),
                            DefaultInput("Введите адрес", addressController),
                            MainText("Электронная почта"),
                            DefaultInput(
                                "Введите адрес почты", emailController),
                            MainText("Номер мобильного телефона"),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Color(0xffF5F6F9),
                                borderRadius: BorderRadius.circular(22.5),
                                border: Border.all(
                                  color: Color.fromRGBO(178, 183, 208, 0.5),
                                  style: BorderStyle.solid,
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "+998",
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  VerticalDivider(
                                    color: Color.fromRGBO(183, 183, 195, 0.5),
                                    thickness: 0.5,
                                  ),
                                  Container(
                                    width: (mediaQuery.size.width -
                                            mediaQuery.padding.left -
                                            mediaQuery.padding.right) *
                                        0.56,
                                    child: TextField(
                                      inputFormatters: [maskFormatter],
                                      controller: phoneController,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Мобильный номер",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .display1),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      sendMessage();
                                    },
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Color(0xffB2B7D0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MainText("Код подтверждения"),
                            DefaultInput("Введите код", codeController),
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
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(38),
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
                              DefaultButton("Изменить контактные данные", () {
                            changeProfile();
                            // setState(() {
                            //   _value = !_value;
                            // });
                            // Navigator.of(context)
                            //     .pushNamed(PasRecognizedScreen.routeName);
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
