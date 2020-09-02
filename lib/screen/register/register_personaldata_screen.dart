import 'package:flutter/material.dart';
import '../home_page.dart';
import '../../widget/default_button.dart';
import '../../widget/default_input.dart';
import '../../widget/main_text.dart';

class RegisterPersonalDataScreen extends StatefulWidget {
  static const routeName = "/register-personal-data";

  @override
  _RegisterPersonalDataScreenState createState() =>
      _RegisterPersonalDataScreenState();
}

class _RegisterPersonalDataScreenState
    extends State<RegisterPersonalDataScreen> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xffF5F6F9),
      appBar: AppBar(
        title: Text(
          "Подтверждение данных",
          style: Theme.of(context).textTheme.display2,
        ),
      ),
      body: SingleChildScrollView(
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
                    MainText("Адрес фактического проживания"),
                    DefaultInput("Введите адрес"),
                    MainText("Электронная почта"),
                    DefaultInput("Введите адрес почты"),
                    MainText("Пароль"),
                    DefaultInput("Придумайте пароль"),
                    MainText("Подтвердите пароль"),
                    DefaultInput("Подтвердите пароль"),
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
                          padding: EdgeInsets.only(left: 10),
                          width: mediaQuery.size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Я принимаю условия ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  "пользовательского соглашения",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
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
                                  setState(() {
                                    _value = !_value;
                                  });
                                  Navigator.of(context)
                                      .pushNamed(HomePage.routeName);
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
