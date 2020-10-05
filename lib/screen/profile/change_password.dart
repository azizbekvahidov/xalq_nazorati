import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/http_get.dart';
import 'package:xalq_nazorati/widget/app_bar/custom_appBar.dart';
import 'package:xalq_nazorati/widget/default_button.dart';
import 'package:xalq_nazorati/widget/text/main_text.dart';
import 'package:xalq_nazorati/widget/shadow_box.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final rePassController = TextEditingController();
  bool _value = false;
  bool _passShow = false;

  void validation() {
    if (oldPassController.text != "" &&
        newPassController.text != "" &&
        rePassController.text != "") {
      setState(() {
        _value = true;
      });
    } else {
      setState(() {
        _value = false;
      });
    }
  }

  Future changePass() async {
    String oldPass = oldPassController.text;
    String newPass = newPassController.text;
    String rePass = rePassController.text;
    var url = '${globals.api_link}/users/change-password';

    Map map = {
      "old_password": oldPass,
      "new_password1": newPass,
      "new_password2": rePass
    };
    Map<String, String> headers = {
      "Authorization": "token ${globals.token}",
    };

    var r1 = await Requests.post(url,
        body: map, headers: headers, verify: false, persistCookies: true);

    dynamic json = r1.json();
    if (r1.statusCode == 200) {
      r1.raiseForStatus();
      Navigator.of(context).pop();
      // addStringToSF(responseBody["token"]);
      // globals.token = responseBody["token"];
    } else {
      print(json);
    }
  }

  addStringToSF(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appbar = CustomAppBar(
      title: "Изменить пароль",
    );
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appbar,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: mediaQuery.size.height - mediaQuery.size.height * 0.17,
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
                            MainText("Старый пароль"),
                            // PassInput("Введите пароль", oldPassController),
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
                                children: [
                                  Container(
                                    width: (mediaQuery.size.width -
                                            mediaQuery.padding.left -
                                            mediaQuery.padding.right) *
                                        0.7,
                                    child: TextField(
                                      onChanged: (text) {
                                        validation();
                                      },
                                      controller: oldPassController,
                                      obscureText: !_passShow,
                                      maxLines: 1,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Введите пароль",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .display1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MainText("Пароль"),
                            // PassInput("Придумайте пароль", newPassController),
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
                                children: [
                                  Container(
                                    width: (mediaQuery.size.width -
                                            mediaQuery.padding.left -
                                            mediaQuery.padding.right) *
                                        0.7,
                                    child: TextField(
                                      onChanged: (text) {
                                        validation();
                                      },
                                      controller: newPassController,
                                      obscureText: !_passShow,
                                      maxLines: 1,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Придумайте пароль",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .display1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MainText("Подтвердите пароль"),
                            // PassInput("Подтвердите пароль", rePassController),
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
                                children: [
                                  Container(
                                    width: (mediaQuery.size.width -
                                            mediaQuery.padding.left -
                                            mediaQuery.padding.right) *
                                        0.7,
                                    child: TextField(
                                      onChanged: (text) {
                                        validation();
                                      },
                                      controller: rePassController,
                                      obscureText: !_passShow,
                                      maxLines: 1,
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Подтвердите пароль",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .display1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                          child: !_value
                              ? DefaultButton(
                                  "Продолжить",
                                  () {},
                                  Color(0xffB2B7D0),
                                )
                              : DefaultButton("Изменить пароль", () {
                                  changePass();
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
