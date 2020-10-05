import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:xalq_nazorati/methods/http_get.dart';
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
  final codeController = TextEditingController();

  Future changeProfile() async {
    // try {
    String address = addressController.text;
    String email = emailController.text;
    String code = codeController.text;
    var url = '${globals.api_link}/users/profile';

    Map map = {
      "address": address,
      "email": email,
    };
    Map<String, String> headers = {
      "Authorization": "token ${globals.token}",
    };

    var r1 =
        await Requests.put(url, body: map, headers: headers, verify: false);

    dynamic json = r1.json();
    if (r1.statusCode == 200) {
      r1.raiseForStatus();
      // Navigator.of(context).pop();
    } else {
      print(json);
    }
    // } catch (e) {
    //   print(e);
    // }
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
                            PhoneIconInput(),
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
                                        "03:00 ",
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
