import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportFeedback extends StatelessWidget {
  var descController = TextEditingController();
  final codeController = TextEditingController();
  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 220,
          height: 241,
          child: Image.asset("assets/img/support.png"),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35, right: 22, left: 22),
          child: Text(
            "У вас есть проблема с приложением напишите нам в телеграм бот",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff313B6C),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "Gilroy",
            ),
          ),
        ),
        InkWell(
          onTap: () {
            launchUrl("tel:1005");
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 72, vertical: 30),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 19),
              height: 50,
              child: Text(
                "Сообщить о проблеме",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Gilroy",
                    color: Colors.white),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff12B79B),
                    Color(0xff00AC8A),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
