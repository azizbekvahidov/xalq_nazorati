import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/screen/main_page/main_page.dart';
import 'package:xalq_nazorati/widget/default_button.dart';

class ProblemFinish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 38),
        height: mediaQuery.size.height - mediaQuery.size.height * 0.17,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Отлично!",
                    style: TextStyle(
                      color: Color(0xff313B6C),
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                  ),
                  Text(
                    "Ваше сообщение сейчас проверяется. Пожалуйста, подождите 1 или 2 дня, чтобы получить результат для вашего сообщения",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff66676C),
                        fontSize: 14,
                        fontFamily: "Gilroy"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  SvgPicture.asset(
                    "assets/img/finish.svg",
                    width: mediaQuery.size.width * 0.6,
                  )
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
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
                            DefaultButton("Продолжить", () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return MainPage();
                          }), (Route<dynamic> route) => false);
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
    );
  }
}
