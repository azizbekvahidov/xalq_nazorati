import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widget/icon_card_list.dart';
import '../../widget/app_bar/custom_appBar.dart';
import '../../widget/shadow_box.dart';

class InfoPage extends StatelessWidget {
  static const routeName = "/info-page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Профиль"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/img/Frame.svg"),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Это интерактивный сервис для эффективного взаимодействия хокимията и горожан, призванный оптимизировать работу с сообщениями о проблемах.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Gilroy",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ShadowBox(
                child: Column(
                  children: [
                    IconCardList("id", "assets/img/share_icon.svg",
                        "Поделиться с друзьями", null, true, null),
                    IconCardList("id", "assets/img/rate_icon.svg",
                        "Оценить приложение", null, true, null),
                    IconCardList("id", "assets/img/support_icon.svg",
                        "Техническая поддержка", null, true, null),
                    IconCardList("id", "assets/img/rule_icon.svg",
                        "Правила модерации", null, false, null),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    "v1.0.0",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff66676C),
                      fontFamily: "Gilroy",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
