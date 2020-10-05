import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:requests/requests.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import '../../widget/app_bar/custom_appBar.dart';
import './pas_recognized_screen.dart';
import '../../widget/default_button.dart';
import '../../widget/input/default_input.dart';
import '../../widget/text/main_text.dart';

class PassRecognizeScreen extends StatefulWidget {
  static const routeName = "/register-pass-recognize";

  @override
  _PassRecognizeScreenState createState() => _PassRecognizeScreenState();
}

class _PassRecognizeScreenState extends State<PassRecognizeScreen> {
  final pnflController = TextEditingController();
  final seriesController = TextEditingController();

  bool _value = false;

  Future sendData() async {
    String pnfl = pnflController.text;
    String series = seriesController.text;
    if (_value && pnfl != "" && series != "") {
      String url = '${globals.api_link}/users/data-from-cep';
      Map map = {"pinpp": pnfl, 'document': series};
      // String url = '${globals.api_link}/users/get-phone';
      var r1 = await Requests.post(url,
          body: map, verify: false, persistCookies: true);
      // print(json.encode(utf8.decode(r1.bytes())));

      if (r1.statusCode == 200) {
        r1.raiseForStatus();

        print("${r1.statusCode} ${r1.content().runtimeType}");
        dynamic json = r1.json();
        // print(json["detail"]);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          settings: const RouteSettings(name: PasRecognizedScreen.routeName),
          builder: (context) => PasRecognizedScreen(
            data: json,
          ),
        ));
      } else {
        print("${r1.statusCode} ${r1.content()}");
      }
    }
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  "Как найти ПНФЛ в паспорте?",
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Container(
                      child: SvgPicture.asset("assets/img/Passport.svg")),
                ),
                FlatButton(
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Закрыть",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar =
        CustomAppBar(title: "Идентификация пользователя");
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: appBar,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: mediaQuery.size.height - mediaQuery.size.height * 0.12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText("ПНФЛ"),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                0.77,
                            child: TextField(
                              controller: pnflController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: 0, bottom: 9),
                                suffix: GestureDetector(
                                  onTap: () {
                                    createAlertDialog(context);
                                  },
                                  child: Container(
                                    width: 19,
                                    height: 19,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(19),
                                      border: Border.all(
                                          color:
                                              Color.fromRGBO(49, 59, 108, 0.5),
                                          style: BorderStyle.solid,
                                          width: 2),
                                    ),
                                    child: Text(
                                      "?",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        fontSize: 13,
                                        color: Color.fromRGBO(49, 59, 108, 0.5),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: "Введите ПНФЛ",
                                hintStyle: Theme.of(context).textTheme.display1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MainText("Серия и номер паспорта"),
                    DefaultInput(
                        "Введите серию и номер паспорта", seriesController),
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
                                    color: Theme.of(context).primaryColor),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Я согласен на использование моей личной информации",
                                style: TextStyle(
                                  fontFamily: "Gilroy",
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
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
                              : DefaultButton("Продолжить", () {
                                  sendData().then((value) {
                                    setState(() {
                                      _value = !_value;
                                    });
                                  });
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
