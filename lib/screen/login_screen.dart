import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xalq_nazorati/screen/home_page.dart';
import 'register/register_phone_screen.dart';
import '../widget/input/pass_input.dart';
import '../widget/default_button.dart';
import '../widget/text/main_text.dart';
import '../widget/input/phone_input.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login-page";
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
                          MainText("Номер мобильного телефона"),
                          PhoneInput(),
                          MainText("Пароль"),
                          PassInput("Введите пароль"),
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
                                  Navigator.of(context)
                                      .pushReplacementNamed(HomePage.routeName);
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
