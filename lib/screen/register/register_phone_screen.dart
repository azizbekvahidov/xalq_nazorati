import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widget/checkbox_custom.dart';
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
    String phone = "+998${phoneController.text}";
    if (phoneController.text == "") phone = "";

    if (!isRegister && phone != "") {
      var url = 'https://new.xalqnazorati.uz/ru/api/users/signup-code';
      var response = await http.post(url, body: {'phone': phone});
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) isRegister = true;
      print(responseBody);
      phoneWiew = responseBody["phone_view"];
    }
// print(await http.read('https://example.com/foobar.txt'));

    if (isRegister && _value) {
      setState(() {
        phoneController.text = "";
        _value = !_value;
      });
      isRegister = false;
      Navigator.of(context).push(MaterialPageRoute(
          settings: const RouteSettings(name: RegisterVerifyScreen.routeName),
          builder: (context) => RegisterVerifyScreen(
                phoneView: phoneWiew,
                phone: phone,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final dWith = mediaQuery.size.width;
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
                                      "У вас уже есть аккаунт?",
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        fontSize: dWith < 400 ? 13 : 14,
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
                                        "Войти",
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
