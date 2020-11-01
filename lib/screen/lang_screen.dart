import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:xalq_nazorati/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login_screen.dart';

class LangScreen extends StatefulWidget {
  @override
  _LangScreenState createState() => _LangScreenState();
}

class _LangScreenState extends State<LangScreen> {
  int btn = 0;
  addStringToSF(String lang, String country) async {
    globals.lang = lang;
    globals.country = country;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', lang);
    prefs.setString('country', country);
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(builder: (context) {
            // Get available height and width of the build area of this widget. Make a choice depending on the size.
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Text(
                      "Портал Xalq Nazorati",
                      style: TextStyle(
                        fontFamily: globals.font,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff313B6C),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Это интерактивный сервис для эффективного взаимодействия хокимията и горожан, призванный оптимизировать работу с обращениями.",
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Улучшим город вместе",
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff313B6C),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "У Ташкентцев появилась дополнительная возможность принять участие в улучшении города своими предложениями или пожаловаться на нарушения.",
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Можно отслеживать статус своего сообщения о проблеме, знакомиться с предложениями других граждан и со статистикой работы над сообщениями. ",
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Напомним, что работа с сообщениями о проблемах регламентируется Пользовательским соглашением, согласно которому сигналы и сообщения о проблемах рассматриваются в течение пятнадцати дней со дня поступления.",
                        style: TextStyle(
                          fontFamily: globals.font,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      color: Colors.white,
                      width: double.infinity,
                      child: Container(
                          child: SvgPicture.asset("assets/img/Frame.svg")),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 80),
            child: SvgPicture.asset("assets/img/Frame.svg"),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: FlatButton(
                    color: btn == 0
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                    onPressed: () {
                      btn = 0;
                      setState(() {});
                      addStringToSF("ru", "RU");
                      EasyLocalization.of(context).locale = Locale("ru", "RU");
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      "Русский",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: btn == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: FlatButton(
                    color: btn == 1
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                    onPressed: () {
                      btn = 1;
                      setState(() {});
                      addStringToSF("uz", "UZ");
                      EasyLocalization.of(context).locale = Locale("uz", "UZ");
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      "O`zbekcha",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: btn == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: FlatButton(
                    color: btn == 2
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                    onPressed: () {
                      btn = 2;
                      setState(() {});
                      addStringToSF("en", "US");
                      EasyLocalization.of(context).locale = Locale("en", "US");
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      "Ўзбекча",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: btn == 2 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                child: FlatButton(
                  onPressed: null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          createAlertDialog(context);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xff66676C),
                          ),
                          child: Text(
                            "?",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Text("about".tr().toString()),
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
